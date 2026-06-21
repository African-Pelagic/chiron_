import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../application/session_flow_controller.dart';
import '../domain/session_summary_grouper.dart';
import 'session_formatters.dart';

class SessionSummaryScreen extends StatelessWidget {
  const SessionSummaryScreen({super.key, required this.sessionFlowController});

  final SessionFlowController sessionFlowController;
  static const SessionSummaryGrouper _summaryGrouper = SessionSummaryGrouper();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sessionFlowController,
      builder: (context, _) {
        final theme = Theme.of(context);
        final completedSession = sessionFlowController.lastCompletedSession;
        final capturedSets = sessionFlowController.capturedSets;
        final groupedSets = _summaryGrouper.group(capturedSets);

        return Scaffold(
          appBar: AppBar(title: const Text('Session Summary')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session complete',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!sessionFlowController.isHydrated)
                        Text(
                          'Loading the last completed session from local storage.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.45,
                          ),
                        )
                      else if (completedSession == null)
                        Text(
                          'No completed session is available yet. Start and end '
                          'a session first to reach this screen with real data.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.45,
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This slice proves independently captured sets can roll up into '
                              'a grouped end-of-session summary and restore that state after relaunch.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _SummaryRow(
                              label: 'Started',
                              value: formatSessionTime(
                                completedSession.startedAt,
                              ),
                            ),
                            _SummaryRow(
                              label: 'Ended',
                              value: formatSessionTime(
                                completedSession.endedAt!,
                              ),
                            ),
                            _SummaryRow(
                              label: 'Duration',
                              value: formatSessionDuration(
                                completedSession.duration,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                groupedSets.isEmpty
                                    ? 'No captured sets were saved in this session.'
                                    : 'Repeated identical captured sets are grouped here while the '
                                        'underlying capture timeline still records each set separately.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ),
                            if (groupedSets.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              for (var index = 0;
                                  index < groupedSets.length;
                                  index++) ...[
                                _SummaryRow(
                                  label: 'Group ${index + 1}',
                                  value: formatGroupedSessionSet(groupedSets[index]),
                                ),
                              ],
                            ],
                          ],
                        ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed:
                            !sessionFlowController.isHydrated ||
                                sessionFlowController.isSubmitting
                            ? null
                            : () {
                                unawaited(() async {
                                  await sessionFlowController.startSession();
                                  if (!context.mounted) {
                                    return;
                                  }

                                  Navigator.of(context).popUntil(
                                    (route) =>
                                        route.settings.name ==
                                            AppRoutePath.session ||
                                        route.isFirst,
                                  );
                                }());
                              },
                        child: Text(
                          sessionFlowController.isSubmitting
                              ? 'Starting...'
                              : 'Start Another Session',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            (route) =>
                                route.settings.name == AppRoutePath.session ||
                                route.isFirst,
                          );
                        },
                        child: const Text('Back to Session Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
