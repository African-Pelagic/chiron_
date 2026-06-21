import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../exercise_library/application/exercise_library_controller.dart';
import '../../exercise_library/domain/exercise_definition.dart';
import '../application/session_flow_controller.dart';
import '../data/category_performance_calculator.dart';
import 'session_formatters.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({
    super.key,
    required this.sessionFlowController,
    required this.exerciseLibraryController,
  });

  final SessionFlowController sessionFlowController;
  final ExerciseLibraryController exerciseLibraryController;

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  static const CategoryPerformanceCalculator _calculator =
      CategoryPerformanceCalculator();

  Future<_PerformanceViewModel>? _viewModelFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    widget.exerciseLibraryController.addListener(_handleExerciseLibraryChange);
  }

  @override
  void dispose() {
    widget.exerciseLibraryController.removeListener(_handleExerciseLibraryChange);
    super.dispose();
  }

  void _handleExerciseLibraryChange() {
    if (!mounted) {
      return;
    }

    final categories = _categoriesFor(widget.exerciseLibraryController.exercises);
    if (categories.isEmpty) {
      if (_selectedCategory != null) {
        setState(() {
          _selectedCategory = null;
          _viewModelFuture = null;
        });
      }
      return;
    }

    final selectedCategory = _selectedCategory;
    if (selectedCategory == null || !categories.contains(selectedCategory)) {
      setState(() {
        _selectedCategory = categories.first;
        _viewModelFuture = _loadForCategory(categories.first);
      });
      return;
    }

    if (_viewModelFuture == null) {
      setState(() {
        _viewModelFuture = _loadForCategory(selectedCategory);
      });
    }
  }

  Future<_PerformanceViewModel> _loadForCategory(String category) async {
    final sessions = await widget.sessionFlowController.fetchAllSessions();
    final records = <SessionPerformanceRecord>[];
    for (final session in sessions) {
      final sets = await widget.sessionFlowController.fetchSetsForSession(
        session.id,
      );
      records.add(SessionPerformanceRecord(session: session, sets: sets));
    }

    final exercises = widget.exerciseLibraryController.exercises;
    final points = _calculator.buildWeeklyAverageMaxSeries(
      exercises: exercises,
      records: records,
      category: category,
      referenceDate: DateTime.now(),
    );

    return _PerformanceViewModel(
      category: category,
      points: points,
      recordCount: records.fold<int>(
        0,
        (count, record) => count + record.sets.length,
      ),
    );
  }

  List<String> _categoriesFor(List<ExerciseDefinition> exercises) {
    final categories = exercises
        .map((exercise) => exercise.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.exerciseLibraryController,
      builder: (context, _) {
        final theme = ShadTheme.of(context);
        final exercises = widget.exerciseLibraryController.exercises;
        final categories = _categoriesFor(exercises);
        final selectedCategory = _selectedCategory;

        if (widget.exerciseLibraryController.isHydrated &&
            categories.isNotEmpty &&
            (selectedCategory == null || !categories.contains(selectedCategory))) {
          _selectedCategory = categories.first;
          _viewModelFuture ??= _loadForCategory(categories.first);
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Performance')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ShadCard(
                title: Text('Weekly category performance', style: theme.textTheme.h3),
                description: Text(
                  'Each weekly point is the average of that category\'s exercise-level max recorded loads over the last 8 weeks.',
                  style: theme.textTheme.muted,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if (!widget.exerciseLibraryController.isHydrated)
                      const Center(child: CircularProgressIndicator())
                    else if (categories.isEmpty)
                      _EmptyStateCard(
                        message:
                            'No exercise categories exist yet. Add or import exercises before performance can be charted.',
                      )
                    else ...[
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        dropdownColor: const Color(0xFF0F172A),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: categories
                            .map(
                              (category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null || value == _selectedCategory) {
                            return;
                          }

                          setState(() {
                            _selectedCategory = value;
                            _viewModelFuture = _loadForCategory(value);
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<_PerformanceViewModel>(
                        future: _viewModelFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 48),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final viewModel = snapshot.data!;
                          final latestValue = viewModel.points
                              .lastWhere(
                                (point) => point.averageMaxLoad != null,
                                orElse: () => WeeklyCategoryPerformancePoint(
                                  weekStart: DateTime(2000),
                                  averageMaxLoad: null,
                                ),
                              )
                              .averageMaxLoad;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _PerformanceBadge(
                                    label: 'Category',
                                    value: viewModel.category,
                                  ),
                                  _PerformanceBadge(
                                    label: 'Window',
                                    value: 'Last 8 weeks',
                                  ),
                                  _PerformanceBadge(
                                    label: 'Latest avg max',
                                    value: latestValue == null
                                        ? 'No data'
                                        : '${formatLoadValue(latestValue)} kg',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _PerformanceChart(points: viewModel.points),
                              const SizedBox(height: 12),
                              Text(
                                'Weeks with no logged weighted sets in this category stay at zero height.',
                                style: theme.textTheme.small.copyWith(
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PerformanceViewModel {
  const _PerformanceViewModel({
    required this.category,
    required this.points,
    required this.recordCount,
  });

  final String category;
  final List<WeeklyCategoryPerformancePoint> points;
  final int recordCount;
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Text(message),
    );
  }
}

class _PerformanceBadge extends StatelessWidget {
  const _PerformanceBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Text('$label: $value', style: theme.textTheme.small),
    );
  }
}

class _PerformanceChart extends StatelessWidget {
  const _PerformanceChart({required this.points});

  final List<WeeklyCategoryPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final maxValue = points.fold<double>(
      0,
      (currentMax, point) => math.max(currentMax, point.averageMaxLoad ?? 0),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: CustomPaint(
              size: const Size(double.infinity, 220),
              painter: _WeeklyLineChartPainter(
                points: points,
                maxValue: maxValue <= 0 ? 1 : maxValue,
                lineColor: theme.colorScheme.primary,
                pointFillColor: theme.colorScheme.background,
                gridColor: theme.colorScheme.border,
                labelColor: theme.colorScheme.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: points
                .map(
                  (point) => Text(
                    '${point.weekStart.month}/${point.weekStart.day}',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _WeeklyLineChartPainter extends CustomPainter {
  const _WeeklyLineChartPainter({
    required this.points,
    required this.maxValue,
    required this.lineColor,
    required this.pointFillColor,
    required this.gridColor,
    required this.labelColor,
  });

  final List<WeeklyCategoryPerformancePoint> points;
  final double maxValue;
  final Color lineColor;
  final Color pointFillColor;
  final Color gridColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - 28;
    final pointSpacing = points.length <= 1 ? size.width : size.width / (points.length - 1);
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final pointStrokePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final pointFillPaint = Paint()
      ..color = pointFillColor
      ..style = PaintingStyle.fill;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final linePath = Path();
    var hasStartedPath = false;

    for (var line = 0; line < 4; line++) {
      final y = (chartHeight / 3) * line;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (var index = 0; index < points.length; index++) {
      final value = points[index].averageMaxLoad ?? 0;
      final normalizedHeight = value <= 0 ? 0.0 : (value / maxValue) * chartHeight;
      final x = points.length <= 1 ? size.width / 2 : index * pointSpacing;
      final y = chartHeight - normalizedHeight;

      if (!hasStartedPath) {
        linePath.moveTo(x, y);
        hasStartedPath = true;
      } else {
        linePath.lineTo(x, y);
      }

      if (value > 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: formatLoadValue(value),
            style: TextStyle(color: labelColor, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: 32);
        textPainter.paint(
          canvas,
          Offset(x - (textPainter.width / 2), math.max(0, y - 14)),
        );
      }
    }

    if (hasStartedPath) {
      canvas.drawPath(linePath, linePaint);
    }

    for (var index = 0; index < points.length; index++) {
      final value = points[index].averageMaxLoad ?? 0;
      final normalizedHeight = value <= 0 ? 0.0 : (value / maxValue) * chartHeight;
      final x = points.length <= 1 ? size.width / 2 : index * pointSpacing;
      final y = chartHeight - normalizedHeight;

      canvas.drawCircle(Offset(x, y), 4, pointFillPaint);
      canvas.drawCircle(Offset(x, y), 4, pointStrokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyLineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.pointFillColor != pointFillColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.labelColor != labelColor;
  }
}
