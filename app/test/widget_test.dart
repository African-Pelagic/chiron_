import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chiron/src/app/app.dart';
import 'package:chiron/src/features/exercise_library/data/csv_file_access.dart';
import 'package:chiron/src/features/exercise_library/data/exercise_library_repository.dart';
import 'package:chiron/src/features/exercise_library/domain/exercise_csv_import_result.dart';
import 'package:chiron/src/features/exercise_library/domain/exercise_definition.dart';
import 'package:chiron/src/features/session/data/exercise_phrase_matcher.dart';
import 'package:chiron/src/features/session/data/session_repository.dart';
import 'package:chiron/src/features/session/domain/captured_set.dart';
import 'package:chiron/src/features/session/domain/captured_set_draft.dart';
import 'package:chiron/src/features/session/domain/workout_session.dart';
import 'package:chiron/src/features/speech/data/voice_capture_service.dart';
import 'package:chiron/src/features/speech/data/voice_transcription_service.dart';

void main() {
  late _FakeExerciseLibraryRepository exerciseLibraryRepository;
  late _FakeSessionRepository sessionRepository;
  late _FakeVoiceCaptureService voiceCaptureService;
  late _FakeVoiceTranscriptionService voiceTranscriptionService;
  late _FakeCsvFileAccess csvFileAccess;

  setUp(() {
    exerciseLibraryRepository = _FakeExerciseLibraryRepository();
    sessionRepository = _FakeSessionRepository();
    voiceCaptureService = _FakeVoiceCaptureService();
    voiceTranscriptionService = _FakeVoiceTranscriptionService();
    csvFileAccess = _FakeCsvFileAccess();
  });

  testWidgets('dashboard starts a session and completed sessions appear in history', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Workout Sessions'), findsOneWidget);
    expect(find.text('Start Session'), findsOneWidget);

    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    expect(find.text('Active session'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).first, '12 dips 30 kilos');
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();

    expect(find.textContaining('12 reps of Dips at 30 kg'), findsOneWidget);

    await tester.tap(find.text('End Session'));
    await tester.pumpAndSettle();

    expect(find.text('Session summary'), findsOneWidget);
    expect(find.text('1 set of 12 Dips at 30 kg'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Previous sessions'), findsOneWidget);
    expect(find.text('#1'), findsWidgets);
  });

  testWidgets('restores an active session after restart', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText).first,
      '12 weighted dips 30 kilos',
    );
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();

    expect(find.text('Active session'), findsOneWidget);
    expect(find.textContaining('Matched from "weighted dips"'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Active session'), findsOneWidget);
    expect(find.textContaining('Matched from "weighted dips"'), findsOneWidget);
  });

  testWidgets('discarding an active session returns to the dashboard', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText).first,
      '12 weighted dips 30 kilos',
    );
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Discard Session'));
    await tester.pumpAndSettle();

    expect(find.text('Workout Sessions'), findsOneWidget);
    expect(find.text('Active session'), findsNothing);
    expect(find.text('#1'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Workout Sessions'), findsOneWidget);
    expect(find.text('Active session'), findsNothing);
    expect(find.text('#1'), findsNothing);
  });

  testWidgets('rejects unresolved exercise phrases', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText).first,
      '10 good morning 60 kg',
    );
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'No canonical exercise or alias matches "good morning". Import it or add it to the exercise library first.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('recording toggle stops and transcribes into a captured set', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    voiceTranscriptionService.transcript = '12 weighted dips, 30 kilos.';

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.stop_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('Transcript:'), findsNothing);
    expect(find.textContaining('12 reps of Dips at 30 kg'), findsOneWidget);
    expect(find.textContaining('Matched from "weighted dips"'), findsOneWidget);
  });

  testWidgets('exports one csv row per captured set', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText).first,
      '12 weighted dips 30 kilos',
    );
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Export Sets CSV'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Saved set export CSV to'), findsOneWidget);
    expect(csvFileAccess.savedSetExportCsv, isNotNull);
    expect(
      csvFileAccess.savedSetExportCsv,
      contains(
        'session_id,session_started_at,session_ended_at,set_id,set_captured_at,canonical_exercise_name,captured_exercise_phrase,reps,load_value,load_unit',
      ),
    );
    expect(csvFileAccess.savedSetExportCsv, contains('Dips'));
    expect(csvFileAccess.savedSetExportCsv, contains('weighted dips'));
    expect(csvFileAccess.savedSetExportCsv, contains(',12,30.0,kg'));
  });

  testWidgets('opens the performance screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      WorkoutApp(
        sessionRepository: sessionRepository,
        exerciseLibraryRepository: exerciseLibraryRepository,
        voiceCaptureService: voiceCaptureService,
        voiceTranscriptionService: voiceTranscriptionService,
        csvFileAccess: csvFileAccess,
        voiceClipPathBuilder: _buildTestVoiceClipPath,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Performance'));
    await tester.pumpAndSettle();

    expect(find.text('Performance'), findsOneWidget);
    expect(find.text('Weekly category performance'), findsOneWidget);
    expect(find.textContaining('Last 8 weeks'), findsOneWidget);
  });
}

Future<String> _buildTestVoiceClipPath(DateTime capturedAt) async {
  return '/tmp/chiron-test-voice-${capturedAt.millisecondsSinceEpoch}.wav';
}

class _FakeSessionRepository implements SessionRepository {
  int _nextId = 1;
  int _nextSetId = 1;
  final List<WorkoutSession> _sessions = <WorkoutSession>[];
  final Map<int, List<CapturedSet>> _sessionSets = <int, List<CapturedSet>>{};
  final ExercisePhraseMatcher _matcher = const ExercisePhraseMatcher();
  final List<ExerciseResolutionCandidate> _candidates =
      const <ExerciseResolutionCandidate>[
        ExerciseResolutionCandidate(
          id: 1,
          name: 'Dips',
          aliases: <String>['weighted dips', 'bar dips'],
        ),
        ExerciseResolutionCandidate(
          id: 2,
          name: 'Pull Up',
          aliases: <String>['pullup', 'weighted pull up'],
        ),
      ];

  @override
  Future<CapturedSet> addCapturedSet({
    required int sessionId,
    required CapturedSetDraft draft,
    required DateTime createdAt,
  }) async {
    final resolvedExercise = _matcher.match(draft.exercisePhrase, _candidates);
    if (resolvedExercise == null) {
      throw UnresolvedExercisePhraseException(draft.exercisePhrase);
    }

    final capturedSet = CapturedSet(
      id: _nextSetId++,
      sessionId: sessionId,
      reps: draft.reps,
      exercisePhrase: draft.exercisePhrase,
      matchedExerciseId: resolvedExercise.exerciseId,
      matchedExerciseName: resolvedExercise.canonicalName,
      loadValue: draft.loadValue,
      loadUnit: draft.loadUnit,
      createdAt: createdAt,
    );
    _sessionSets.putIfAbsent(sessionId, () => <CapturedSet>[]).add(capturedSet);
    return capturedSet;
  }

  @override
  Future<WorkoutSession> completeSession(
    WorkoutSession session,
    DateTime endedAt,
  ) async {
    final completedSession = session.end(endedAt);
    final index = _sessions.indexWhere((item) => item.id == session.id);
    _sessions[index] = completedSession;
    return completedSession;
  }

  @override
  Future<void> discardSession(WorkoutSession session) async {
    _sessions.removeWhere((item) => item.id == session.id);
    _sessionSets.remove(session.id);
  }

  @override
  Future<WorkoutSession> createSession(DateTime startedAt) async {
    final session = WorkoutSession(id: _nextId++, startedAt: startedAt);
    _sessions.add(session);
    return session;
  }

  @override
  Future<WorkoutSession?> fetchActiveSession() async {
    for (final session in _sessions.reversed) {
      if (session.isActive) {
        return session;
      }
    }

    return null;
  }

  @override
  Future<List<WorkoutSession>> fetchCompletedSessions() async {
    final completed = _sessions.where((session) => !session.isActive).toList();
    completed.sort((left, right) => right.startedAt.compareTo(left.startedAt));
    return completed;
  }

  @override
  Future<List<WorkoutSession>> fetchAllSessions() async {
    return List<WorkoutSession>.from(_sessions);
  }

  @override
  Future<WorkoutSession?> fetchLastCompletedSession() async {
    final completedSessions = await fetchCompletedSessions();
    return completedSessions.isEmpty ? null : completedSessions.first;
  }

  @override
  Future<WorkoutSession?> fetchSessionById(int id) async {
    for (final session in _sessions) {
      if (session.id == id) {
        return session;
      }
    }

    return null;
  }

  @override
  Future<List<CapturedSet>> fetchSetsForSession(int sessionId) async {
    return List<CapturedSet>.from(_sessionSets[sessionId] ?? const []);
  }
}

class _FakeExerciseLibraryRepository implements ExerciseLibraryRepository {
  @override
  Future<void> createExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {}

  @override
  Future<ExerciseCsvImportResult> importExercisesFromCsv(String csvText) async {
    return const ExerciseCsvImportResult(
      createdExercises: 0,
      updatedExercises: 0,
      addedAliases: 0,
      skippedRows: 0,
    );
  }

  @override
  Future<void> setExerciseActive({
    required int id,
    required bool isActive,
  }) async {}

  @override
  Future<void> updateExercise({
    required int id,
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {}

  @override
  Stream<List<ExerciseDefinition>> watchExercises() {
    return Stream<List<ExerciseDefinition>>.value(
      const <ExerciseDefinition>[
        ExerciseDefinition(
          id: 1,
          name: 'Dips',
          category: 'push',
          defaultUnit: 'kg',
          isActive: true,
          aliases: <String>['weighted dips', 'bar dips'],
        ),
        ExerciseDefinition(
          id: 2,
          name: 'Pull Up',
          category: 'pull',
          defaultUnit: 'kg',
          isActive: true,
          aliases: <String>['pullup', 'weighted pull up'],
        ),
      ],
    );
  }
}

class _FakeVoiceCaptureService implements VoiceCaptureService {
  String? _lastPath;

  @override
  Future<void> cancel() async {
    _lastPath = null;
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<void> start({required String path}) async {
    _lastPath = path;
  }

  @override
  Future<String?> stop() async => _lastPath;
}

class _FakeVoiceTranscriptionService implements VoiceTranscriptionService {
  String transcript = '12 weighted dips 30 kilos';

  @override
  Future<String> transcribe({required String audioPath}) async => transcript;
}

class _FakeCsvFileAccess implements CsvFileAccess {
  String? savedSetExportCsv;

  @override
  Future<String?> pickCsvText() async => null;

  @override
  Future<String?> saveSchemaCsv(String csvText) async => '/tmp/schema.csv';

  @override
  Future<String?> saveSetExportCsv(String csvText) async {
    savedSetExportCsv = csvText;
    return '/tmp/chiron_sets_export.csv';
  }
}
