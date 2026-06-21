import 'package:flutter/foundation.dart';

import '../data/exercise_phrase_matcher.dart';
import '../data/session_csv_exporter.dart';
import '../data/typed_set_parser.dart';
import '../domain/captured_set.dart';
import '../data/session_repository.dart';
import '../domain/workout_session.dart';

enum SessionFlowStatus { loading, idle, active, completed }

class SessionFlowController extends ChangeNotifier {
  SessionFlowController({
    required this.sessionRepository,
    DateTime Function()? now,
    TypedSetParser? typedSetParser,
    SessionCsvExporter? sessionCsvExporter,
  }) : _now = now ?? DateTime.now,
       _typedSetParser = typedSetParser ?? const TypedSetParser(),
       _sessionCsvExporter = sessionCsvExporter ?? const SessionCsvExporter();

  final SessionRepository sessionRepository;
  final DateTime Function() _now;
  final TypedSetParser _typedSetParser;
  final SessionCsvExporter _sessionCsvExporter;

  WorkoutSession? _activeSession;
  WorkoutSession? _lastCompletedSession;
  List<WorkoutSession> _sessionHistory = const [];
  List<CapturedSet> _capturedSets = const [];
  bool _isHydrated = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  Future<void>? _hydrationFuture;

  SessionFlowStatus get status {
    if (!_isHydrated) {
      return SessionFlowStatus.loading;
    }

    if (_activeSession != null) {
      return SessionFlowStatus.active;
    }

    if (_lastCompletedSession != null) {
      return SessionFlowStatus.completed;
    }

    return SessionFlowStatus.idle;
  }

  WorkoutSession? get activeSession => _activeSession;
  WorkoutSession? get lastCompletedSession => _lastCompletedSession;
  List<WorkoutSession> get sessionHistory => List.unmodifiable(_sessionHistory);
  List<CapturedSet> get capturedSets => List.unmodifiable(_capturedSets);
  bool get isHydrated => _isHydrated;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<void> hydrate() {
    return _hydrationFuture ??= _hydrate();
  }

  Future<void> startSession() async {
    if (!_isHydrated || _isSubmitting || _activeSession != null) {
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      _activeSession = await sessionRepository.createSession(_now());
      _lastCompletedSession = null;
      _capturedSets = const [];
      _errorMessage = null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> endSession() async {
    if (!_isHydrated || _isSubmitting) {
      return;
    }

    final session = _activeSession;
    if (session == null) {
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      _lastCompletedSession = await sessionRepository.completeSession(
        session,
        _now(),
      );
      _activeSession = null;
      _errorMessage = null;
      await _loadSessionHistory();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> discardSession() async {
    if (!_isHydrated || _isSubmitting) {
      return;
    }

    final session = _activeSession;
    if (session == null) {
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      await sessionRepository.discardSession(session);
      _activeSession = null;
      _capturedSets = const [];
      _errorMessage = null;
      await _loadSessionHistory();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> addTypedSet(String input) async {
    if (!_isHydrated || _isSubmitting) {
      return false;
    }

    final session = _activeSession;
    if (session == null) {
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final draft = _typedSetParser.parse(input);
      final capturedSet = await sessionRepository.addCapturedSet(
        sessionId: session.id,
        draft: draft,
        createdAt: _now(),
      );
      _capturedSets = <CapturedSet>[..._capturedSets, capturedSet];
      return true;
    } on TypedSetFormatException catch (error) {
      _errorMessage = error.message;
      return false;
    } on UnresolvedExercisePhraseException catch (error) {
      _errorMessage =
          'No canonical exercise or alias matches "${error.phrase}". '
          'Import it or add it to the exercise library first.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _hydrate() async {
    try {
      _activeSession = await sessionRepository.fetchActiveSession();
      _lastCompletedSession = await sessionRepository
          .fetchLastCompletedSession();
      await _loadSessionHistory();
      await _loadCapturedSetsForCurrentSession();
    } finally {
      _isHydrated = true;
      notifyListeners();
    }
  }

  Future<WorkoutSession?> fetchSessionById(int id) {
    return sessionRepository.fetchSessionById(id);
  }

  Future<List<WorkoutSession>> fetchAllSessions() {
    return sessionRepository.fetchAllSessions();
  }

  Future<List<CapturedSet>> fetchSetsForSession(int sessionId) {
    return sessionRepository.fetchSetsForSession(sessionId);
  }

  Future<String> exportAllSetsCsv() async {
    final sessions = await sessionRepository.fetchAllSessions();
    final exportRecords = <SessionCsvExportRecord>[];

    for (final session in sessions) {
      final sets = await sessionRepository.fetchSetsForSession(session.id);
      exportRecords.add(SessionCsvExportRecord(session: session, sets: sets));
    }

    return _sessionCsvExporter.export(exportRecords);
  }

  Future<void> _loadSessionHistory() async {
    _sessionHistory = await sessionRepository.fetchCompletedSessions();
  }

  Future<void> _loadCapturedSetsForCurrentSession() async {
    final session = _activeSession ?? _lastCompletedSession;
    if (session == null) {
      _capturedSets = const [];
      return;
    }

    _capturedSets = await sessionRepository.fetchSetsForSession(session.id);
  }
}
