import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../app/router.dart';
import '../application/session_flow_controller.dart';
import '../domain/captured_set.dart';
import '../domain/grouped_session_set.dart';
import '../domain/session_summary_grouper.dart';
import '../domain/workout_session.dart';
import 'session_formatters.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({
    super.key,
    required this.sessionFlowController,
    required this.sessionId,
  });

  final SessionFlowController sessionFlowController;
  final int sessionId;

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  late Future<_SessionDetailData?> _detailFuture;
  static const SessionSummaryGrouper _summaryGrouper = SessionSummaryGrouper();

  @override
  void initState() {
    super.initState();
    _detailFuture = _load();
  }

  Future<_SessionDetailData?> _load() async {
    final session = await widget.sessionFlowController.fetchSessionById(
      widget.sessionId,
    );
    if (session == null) {
      return null;
    }

    final sets = await widget.sessionFlowController.fetchSetsForSession(
      session.id,
    );
    return _SessionDetailData(session: session, sets: sets);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SessionDetailData?>(
      future: _detailFuture,
      builder: (context, snapshot) {
        final theme = ShadTheme.of(context);

        return Scaffold(
          appBar: AppBar(title: const Text('Session Detail')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (!snapshot.hasData)
                ShadCard(
                  title: Text('Loading session', style: theme.textTheme.h4),
                  description: const Text(
                    'Loading the session summary and set rows from local storage.',
                  ),
                )
              else if (snapshot.data == null)
                ShadCard(
                  title: Text('Session not found', style: theme.textTheme.h4),
                  description: const Text(
                    'That session is no longer available in local storage.',
                  ),
                )
              else ...[
                _SessionStatsCard(data: snapshot.data!),
                const SizedBox(height: 16),
                _SessionSetTable(sets: snapshot.data!.sets),
                const SizedBox(height: 16),
                ShadButton(
                  onPressed: () {
                    unawaited(() async {
                      await widget.sessionFlowController.startSession();
                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).popUntil(
                        (route) =>
                            route.settings.name == AppRoutePath.session ||
                            route.isFirst,
                      );
                    }());
                  },
                  child: const Text('Start Another Session'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SessionStatsCard extends StatelessWidget {
  const _SessionStatsCard({required this.data});

  final _SessionDetailData data;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final groupedSets = _SessionDetailScreenState._summaryGrouper.group(
      data.sets,
    );
    final uniqueExercises = data.sets
        .map((set) => set.displayExerciseName)
        .toSet()
        .length;

    return ShadCard(
      title: Text('Session summary', style: theme.textTheme.h4),
      description: Text(
        'Grouped stats at the top, with the underlying set timeline kept below as individual rows.',
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
              _StatChip(label: 'Session', value: '#${data.session.id}'),
              _StatChip(
                label: 'Duration',
                value: formatSessionDuration(data.session.duration),
              ),
              _StatChip(label: 'Sets', value: '${data.sets.length}'),
              _StatChip(label: 'Exercises', value: '$uniqueExercises'),
            ],
          ),
          const SizedBox(height: 20),
          _SummaryLine(
            label: 'Started',
            value: formatSessionDateTime(data.session.startedAt),
          ),
          _SummaryLine(
            label: 'Ended',
            value: data.session.endedAt == null
                ? 'Active'
                : formatSessionDateTime(data.session.endedAt!),
          ),
          const SizedBox(height: 16),
          for (final group in groupedSets) ...[
            _GroupedSetBadge(group: group),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SessionSetTable extends StatelessWidget {
  const _SessionSetTable({required this.sets});

  final List<CapturedSet> sets;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      title: Text('Set rows', style: theme.textTheme.h4),
      description: Text(
        'Each captured set remains stored independently even when the summary groups repeated rows.',
        style: theme.textTheme.muted,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: _tableHeightForRowCount(sets.length),
            ),
            child: ShadTable.list(
              columnSpanExtent: (index) {
                if (index == 0) {
                  return const FixedTableSpanExtent(52);
                }
                return const RemainingTableSpanExtent();
              },
              header: const [
                ShadTableCell.header(child: Text('#')),
                ShadTableCell.header(child: Text('Captured set')),
              ],
              children: sets.isEmpty
                  ? const [
                      [
                        ShadTableCell(child: Text('-')),
                        ShadTableCell(child: Text('No sets')),
                      ],
                    ]
                  : List<Iterable<ShadTableCell>>.generate(
                      sets.length,
                      (index) {
                        final set = sets[index];
                        final setSummary =
                            '${set.reps} ${set.reps == 1 ? 'rep' : 'reps'} of ${set.displayExerciseName}'
                            '${set.hasLoad ? ' at ${formatLoadValue(set.loadValue!)} ${set.loadUnit}' : ''}';
                        final detailText = <String>[
                          'Captured ${formatSessionTime(set.createdAt)}',
                          if (set.isResolved)
                            'Matched from "${set.exercisePhrase}"',
                        ].join('  |  ');
                        return <ShadTableCell>[
                          ShadTableCell(child: Text('${index + 1}')),
                          ShadTableCell(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$setSummary\n',
                                    style: theme.textTheme.p.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: detailText,
                                    style: theme.textTheme.small.copyWith(
                                      color: theme.colorScheme.mutedForeground,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ];
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  double _tableHeightForRowCount(int rowCount) {
    const rowHeight = 48.0;
    const headerHeight = 48.0;
    final visibleRows = rowCount.clamp(1, 8);
    return headerHeight + (visibleRows * rowHeight) + 2;
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

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

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.small),
          ),
          Text(
            value,
            style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _GroupedSetBadge extends StatelessWidget {
  const _GroupedSetBadge({required this.group});

  final GroupedSessionSet group;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Text(
        formatGroupedSessionSet(group),
        style: theme.textTheme.p,
      ),
    );
  }
}

class _SessionDetailData {
  const _SessionDetailData({required this.session, required this.sets});

  final WorkoutSession session;
  final List<CapturedSet> sets;
}
