import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../app/router.dart';
import '../../exercise_library/data/csv_file_access.dart';
import '../../speech/application/voice_capture_controller.dart';
import '../application/session_flow_controller.dart';
import '../domain/captured_set.dart';
import '../domain/workout_session.dart';
import 'session_formatters.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({
    super.key,
    required this.sessionFlowController,
    required this.voiceCaptureController,
    required this.csvFileAccess,
  });

  final SessionFlowController sessionFlowController;
  final VoiceCaptureController voiceCaptureController;
  final CsvFileAccess csvFileAccess;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final TextEditingController _setPhraseController;

  @override
  void initState() {
    super.initState();
    _setPhraseController = TextEditingController();
  }

  @override
  void dispose() {
    _setPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        widget.sessionFlowController,
        widget.voiceCaptureController,
      ]),
      builder: (context, _) {
        final controller = widget.sessionFlowController;
        final activeSession = controller.activeSession;

        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'assets/branding/chiron-dark.png',
              height: 28,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            actions: [
              IconButton(
                tooltip: 'Exercise Library',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutePath.exerciseLibrary);
                },
                icon: const Icon(Icons.table_chart_outlined),
              ),
              IconButton(
                tooltip: 'CSV Import',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutePath.importCsv);
                },
                icon: const Icon(Icons.upload_file_outlined),
              ),
              IconButton(
                tooltip: 'Performance',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutePath.performance);
                },
                icon: const Icon(Icons.show_chart_outlined),
              ),
              IconButton(
                tooltip: 'Export Sets CSV',
                onPressed: controller.isHydrated
                    ? () {
                        unawaited(_exportSetsCsv(context));
                      }
                    : null,
                icon: const Icon(Icons.download_outlined),
              ),
            ],
          ),
          body: controller.isHydrated
              ? activeSession == null
                    ? _DashboardView(
                        sessionFlowController: controller,
                        onOpenSession: (session) {
                          Navigator.of(context).pushNamed(
                            AppRoutePath.sessionDetail,
                            arguments: SessionDetailRouteArguments(
                              sessionId: session.id,
                            ),
                          );
                        },
                      )
                    : _ActiveSessionView(
                        sessionFlowController: controller,
                        voiceCaptureController: widget.voiceCaptureController,
                        setPhraseController: _setPhraseController,
                        onTranscriptReady: _ingestTranscript,
                        onDiscardSession: () async {
                          await controller.discardSession();
                          await widget.voiceCaptureController.discardLastClip();
                        },
                        onEndSession: () async {
                          await controller.endSession();
                          final completed = controller.lastCompletedSession;
                          if (!context.mounted || completed == null) {
                            return;
                          }

                          Navigator.of(context).pushNamed(
                            AppRoutePath.sessionDetail,
                            arguments: SessionDetailRouteArguments(
                              sessionId: completed.id,
                            ),
                          );
                        },
                      )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<void> _ingestTranscript(String transcript) async {
    final sessionFlowController = widget.sessionFlowController;
    final voiceCaptureController = widget.voiceCaptureController;

    _setPhraseController
      ..text = transcript
      ..selection = TextSelection.collapsed(offset: transcript.length);
    sessionFlowController.clearError();

    final wasAdded = await sessionFlowController.addTypedSet(transcript);
    if (wasAdded) {
      _setPhraseController.clear();
      await voiceCaptureController.discardLastClip();
    }
  }

  Future<void> _exportSetsCsv(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final csvText = await widget.sessionFlowController.exportAllSetsCsv();
      final savedPath = await widget.csvFileAccess.saveSetExportCsv(csvText);
      if (!mounted) {
        return;
      }

      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              savedPath == null
                  ? 'Set export was cancelled.'
                  : 'Saved set export CSV to $savedPath',
            ),
          ),
        );
    } catch (_) {
      if (!mounted) {
        return;
      }

      messenger
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Set export failed. Try again.'),
          ),
        );
    }
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({
    required this.sessionFlowController,
    required this.onOpenSession,
  });

  final SessionFlowController sessionFlowController;
  final ValueChanged<WorkoutSession> onOpenSession;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final history = sessionFlowController.sessionHistory;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ShadCard(
          title: Text('Workout Sessions', style: theme.textTheme.h3),
          description: Text(
            'Start a new voice-first session, then jump back into any completed session from the table below.',
            style: theme.textTheme.muted,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ShadButton(
                onPressed: sessionFlowController.isSubmitting
                    ? null
                    : () {
                        unawaited(sessionFlowController.startSession());
                      },
                child: Text(
                  sessionFlowController.isSubmitting
                      ? 'Starting...'
                      : 'Start Session',
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricBadge(
                    label: 'Previous sessions',
                    value: '${history.length}',
                  ),
                  if (history.isNotEmpty)
                    _MetricBadge(
                      label: 'Latest',
                      value: formatSessionDate(history.first.startedAt),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadCard(
          title: Text('Previous sessions', style: theme.textTheme.h4),
          description: Text(
            'Tap any row to open its grouped stats and underlying set rows.',
            style: theme.textTheme.muted,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (history.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.border),
                  ),
                  child: const Text(
                    'No completed sessions yet. Finish your first session to populate this table.',
                  ),
                )
              else
                SizedBox(
                  height: _historyTableHeight(history.length),
                  child: ShadTable.list(
                    onRowTap: (index) {
                      onOpenSession(history[index]);
                    },
                    columnSpanExtent: (index) {
                      if (index == 0) {
                        return const FixedTableSpanExtent(84);
                      }
                      if (index == 1) {
                        return const FixedTableSpanExtent(124);
                      }
                      if (index == 2) {
                        return const FixedTableSpanExtent(88);
                      }
                      if (index == 3) {
                        return const FixedTableSpanExtent(88);
                      }
                      return const RemainingTableSpanExtent();
                    },
                    header: const [
                      ShadTableCell.header(child: Text('Session')),
                      ShadTableCell.header(child: Text('Date')),
                      ShadTableCell.header(child: Text('Started')),
                      ShadTableCell.header(child: Text('Ended')),
                      ShadTableCell.header(child: Text('Duration')),
                    ],
                    children: history.map((session) {
                      return <ShadTableCell>[
                        ShadTableCell(child: Text('#${session.id}')),
                        ShadTableCell(
                          child: Text(formatSessionDate(session.startedAt)),
                        ),
                        ShadTableCell(
                          child: Text(formatSessionTime(session.startedAt)),
                        ),
                        ShadTableCell(
                          child: Text(
                            session.endedAt == null
                                ? 'Active'
                                : formatSessionTime(session.endedAt!),
                          ),
                        ),
                        ShadTableCell(
                          child: Text(formatSessionDuration(session.duration)),
                        ),
                      ];
                    }),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  double _historyTableHeight(int rowCount) {
    const rowHeight = 48.0;
    const headerHeight = 48.0;
    final visibleRows = rowCount.clamp(1, 6);
    return headerHeight + (visibleRows * rowHeight) + 2;
  }
}

class _ActiveSessionView extends StatelessWidget {
  const _ActiveSessionView({
    required this.sessionFlowController,
    required this.voiceCaptureController,
    required this.setPhraseController,
    required this.onTranscriptReady,
    required this.onDiscardSession,
    required this.onEndSession,
  });

  final SessionFlowController sessionFlowController;
  final VoiceCaptureController voiceCaptureController;
  final TextEditingController setPhraseController;
  final Future<void> Function(String transcript) onTranscriptReady;
  final Future<void> Function() onDiscardSession;
  final Future<void> Function() onEndSession;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final activeSession = sessionFlowController.activeSession!;
    final capturedSets = sessionFlowController.capturedSets;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ShadCard(
          title: Text('Active session', style: theme.textTheme.h3),
          description: Text(
            'The record control is a single toggle: start recording, then stop to transcribe and push the phrase into the logging pipeline.',
            style: theme.textTheme.muted,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _MetricBadge(
                    label: 'Session',
                    value: '#${activeSession.id}',
                  ),
                  _MetricBadge(
                    label: 'Started',
                    value: formatSessionDateTime(activeSession.startedAt),
                  ),
                  _MetricBadge(
                    label: 'Captured sets',
                    value: '${capturedSets.length}',
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: _RecordingToggleButton(
                  voiceCaptureController: voiceCaptureController,
                  onTranscriptReady: onTranscriptReady,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                voiceCaptureController.isRecording
                    ? 'Recording now. Tap again to stop and transcribe.'
                    : voiceCaptureController.isTranscribing
                    ? 'Transcribing the latest clip locally with Whisper.'
                    : 'Tap the button to capture a set phrase.',
                style: theme.textTheme.muted,
                textAlign: TextAlign.center,
              ),
              if (voiceCaptureController.lastTranscript case final transcript?) ...[
                const SizedBox(height: 12),
                Text(
                  'Transcript: "$transcript"',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.small,
                ),
              ],
              if (voiceCaptureController.errorMessage case final message?) ...[
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.destructive),
                ),
              ],
              if (!voiceCaptureController.isRecording &&
                  voiceCaptureController.lastClip != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: voiceCaptureController.isBusy ||
                                sessionFlowController.isSubmitting
                            ? null
                            : () {
                                unawaited(() async {
                                  final transcript = await voiceCaptureController
                                      .transcribeLastClip();
                                  if (transcript != null) {
                                    await onTranscriptReady(transcript);
                                  }
                                }());
                              },
                        child: Text(
                          voiceCaptureController.isTranscribing
                              ? 'Transcribing...'
                              : 'Retry Transcription',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: voiceCaptureController.isBusy
                            ? null
                            : () {
                                unawaited(
                                  voiceCaptureController.discardLastClip(),
                                );
                              },
                        child: const Text('Discard Clip'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadCard(
          title: Text('Fallback text entry', style: theme.textTheme.h4),
          description: Text(
            'Manual entry stays available as the operator escape hatch when voice needs correcting.',
            style: theme.textTheme.muted,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ShadInput(
                controller: setPhraseController,
                placeholder: const Text('12 dips 30 kilos'),
                maxLines: 2,
                textInputAction: TextInputAction.done,
                onChanged: (_) => sessionFlowController.clearError(),
                onSubmitted: (_) {
                  unawaited(_addTypedSet());
                },
              ),
              if (sessionFlowController.errorMessage case final message?) ...[
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(color: theme.colorScheme.destructive),
                ),
              ],
              const SizedBox(height: 16),
              ShadButton(
                onPressed: sessionFlowController.isSubmitting
                    ? null
                    : () {
                        unawaited(_addTypedSet());
                      },
                child: Text(
                  sessionFlowController.isSubmitting ? 'Saving...' : 'Add Set',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadCard(
          title: Text('Captured set rows', style: theme.textTheme.h4),
          description: Text(
            'Every set is persisted independently in capture order.',
            style: theme.textTheme.muted,
          ),
          footer: Row(
            children: [
              Expanded(
                child: ShadButton.destructive(
                  onPressed: sessionFlowController.isSubmitting
                      ? null
                      : () {
                          unawaited(onDiscardSession());
                        },
                  child: Text(
                    sessionFlowController.isSubmitting
                        ? 'Discarding...'
                        : 'Discard Session',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShadButton.outline(
                  onPressed: sessionFlowController.isSubmitting
                      ? null
                      : () {
                          unawaited(onEndSession());
                        },
                  child: Text(
                    sessionFlowController.isSubmitting
                        ? 'Ending...'
                        : 'End Session',
                  ),
                ),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: _capturedSetsTableHeight(capturedSets.length),
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
                  children: capturedSets.isEmpty
                      ? const [
                          [
                            ShadTableCell(child: Text('-')),
                            ShadTableCell(child: Text('No sets yet')),
                          ],
                        ]
                      : List<Iterable<ShadTableCell>>.generate(
                          capturedSets.length,
                          (index) => _buildSetRow(
                            context,
                            capturedSets[index],
                            index,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addTypedSet() async {
    final wasAdded = await sessionFlowController.addTypedSet(
      setPhraseController.text,
    );
    if (wasAdded) {
      setPhraseController.clear();
    }
  }

  Iterable<ShadTableCell> _buildSetRow(
    BuildContext context,
    CapturedSet set,
    int index,
  ) {
    final theme = ShadTheme.of(context);
    final setSummary =
        '${set.reps} ${set.reps == 1 ? 'rep' : 'reps'} of ${set.displayExerciseName}'
        '${set.hasLoad ? ' at ${formatLoadValue(set.loadValue!)} ${set.loadUnit}' : ''}';
    final details = <String>[
      'Captured ${formatSessionTime(set.createdAt)}',
      if (set.isResolved) 'Matched from "${set.exercisePhrase}"',
    ];

    return <ShadTableCell>[
      ShadTableCell(child: Text('${index + 1}')),
      ShadTableCell(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$setSummary\n',
                style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: details.join(' | '),
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
  }

  double _capturedSetsTableHeight(int rowCount) {
    const rowHeight = 48.0;
    const headerHeight = 48.0;
    final visibleRows = rowCount.clamp(1, 8);
    return headerHeight + (visibleRows * rowHeight) + 2;
  }
}

class _RecordingToggleButton extends StatelessWidget {
  const _RecordingToggleButton({
    required this.voiceCaptureController,
    required this.onTranscriptReady,
  });

  final VoiceCaptureController voiceCaptureController;
  final Future<void> Function(String transcript) onTranscriptReady;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isRecording = voiceCaptureController.isRecording;
    final isBusy = voiceCaptureController.isBusy;

    return GestureDetector(
      onTap: isBusy
          ? null
          : () {
              unawaited(() async {
                if (isRecording) {
                  final transcript = await voiceCaptureController
                      .stopRecordingAndTranscribe();
                  if (transcript != null) {
                    await onTranscriptReady(transcript);
                  }
                  return;
                }

                await voiceCaptureController.startRecording();
              }());
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording
              ? theme.colorScheme.destructive
              : theme.colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: (isRecording
                      ? theme.colorScheme.destructive
                      : theme.colorScheme.primary)
                  .withValues(alpha: 0.25),
              blurRadius: 28,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Icon(
          isRecording ? Icons.stop_rounded : Icons.mic_rounded,
          color: isRecording
              ? theme.colorScheme.destructiveForeground
              : theme.colorScheme.primaryForeground,
          size: 74,
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({required this.label, required this.value});

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
