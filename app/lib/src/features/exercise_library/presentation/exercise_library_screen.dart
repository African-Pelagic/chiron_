import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../app/router.dart';
import '../application/exercise_library_controller.dart';
import '../domain/exercise_definition.dart';

class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({
    super.key,
    required this.exerciseLibraryController,
  });

  final ExerciseLibraryController exerciseLibraryController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: exerciseLibraryController,
      builder: (context, _) {
        final theme = ShadTheme.of(context);
        final exercises = exerciseLibraryController.exercises;

        return Scaffold(
          appBar: AppBar(title: const Text('Exercise Library')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ShadCard(
                title: Text('Exercise catalog', style: theme.textTheme.h3),
                description: Text(
                  'Manage the canonical exercise records that the parser and alias matcher resolve against.',
                  style: theme.textTheme.muted,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _LibraryBadge(
                          label: 'Active',
                          value:
                              '${exerciseLibraryController.activeExercises.length}',
                        ),
                        _LibraryBadge(
                          label: 'Archived',
                          value:
                              '${exerciseLibraryController.archivedExercises.length}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ShadButton(
                            onPressed: exerciseLibraryController.isSaving
                                ? null
                                : () {
                                    Navigator.of(context).pushNamed(
                                      AppRoutePath.exerciseEditor,
                                    );
                                  },
                            child: const Text('Add Exercise'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ShadButton.outline(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutePath.importCsv,
                              );
                            },
                            child: const Text('CSV Import'),
                          ),
                        ),
                      ],
                    ),
                    if (exerciseLibraryController.errorMessage
                        case final message?) ...[
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: TextStyle(color: theme.colorScheme.destructive),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ShadCard(
                title: Text('Exercise rows', style: theme.textTheme.h4),
                description: Text(
                  'Each row shows the available exercise-record values plus edit/archive controls.',
                  style: theme.textTheme.muted,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    if (!exerciseLibraryController.isHydrated)
                      const Center(child: CircularProgressIndicator())
                    else if (exercises.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.border),
                        ),
                        child: const Text(
                          'No exercises yet. Add a record or import a CSV from the device.',
                        ),
                      )
                    else
                      SizedBox(
                        height: _tableHeightForRowCount(exercises.length),
                        child: ShadTable.list(
                          onRowTap: (index) {
                            if (index < 0 || index >= exercises.length) {
                              return;
                            }

                            Navigator.of(context).pushNamed(
                              AppRoutePath.exerciseEditor,
                              arguments: ExerciseEditorRouteArguments(
                                exercise: exercises[index],
                              ),
                            );
                          },
                          columnSpanExtent: (index) {
                            if (index == 0) {
                              return const FixedTableSpanExtent(48);
                            }
                            return const RemainingTableSpanExtent();
                          },
                          header: const [
                            ShadTableCell.header(child: Text('ID')),
                            ShadTableCell.header(child: Text('Exercise record')),
                          ],
                          children: exercises.map(
                            (exercise) => _buildExerciseRow(context, exercise),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Iterable<ShadTableCell> _buildExerciseRow(
    BuildContext context,
    ExerciseDefinition exercise,
  ) {
    final theme = ShadTheme.of(context);
    final aliases = exercise.aliases.isEmpty
        ? 'No aliases'
        : exercise.aliases.join(', ');
    final summaryStyle = theme.textTheme.small.copyWith(height: 1.15);

    return <ShadTableCell>[
      ShadTableCell(child: Text('${exercise.id}')),
      ShadTableCell(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${exercise.name}\n',
                style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text:
                    'Category: ${exercise.category} | Unit: ${exercise.defaultUnit} | Status: ${exercise.isActive ? 'Active' : 'Archived'} | Aliases: $aliases',
                style: summaryStyle.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
  }

  double _tableHeightForRowCount(int rowCount) {
    const rowHeight = 48.0;
    const headerHeight = 48.0;
    final visibleRows = rowCount.clamp(1, 8);
    return headerHeight + (visibleRows * rowHeight) + 2;
  }
}

class _LibraryBadge extends StatelessWidget {
  const _LibraryBadge({required this.label, required this.value});

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
