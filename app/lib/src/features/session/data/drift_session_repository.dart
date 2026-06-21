import '../../../core/database/app_database.dart';
import '../domain/captured_set.dart';
import '../domain/captured_set_draft.dart';
import '../domain/workout_session.dart';
import 'exercise_phrase_matcher.dart';
import 'session_repository.dart';

class DriftSessionRepository implements SessionRepository {
  DriftSessionRepository(
    this._database, {
    ExercisePhraseMatcher? exercisePhraseMatcher,
  }) : _exercisePhraseMatcher =
           exercisePhraseMatcher ?? const ExercisePhraseMatcher();

  final AppDatabase _database;
  final ExercisePhraseMatcher _exercisePhraseMatcher;

  @override
  Future<CapturedSet> addCapturedSet({
    required int sessionId,
    required CapturedSetDraft draft,
    required DateTime createdAt,
  }) async {
    final resolvedExercise = await _resolveExercisePhrase(draft.exercisePhrase);
    if (resolvedExercise == null) {
      throw UnresolvedExercisePhraseException(draft.exercisePhrase);
    }

    final persistedSet = await _database.insertSessionSet(
      sessionId: sessionId,
      reps: draft.reps,
      exercisePhrase: draft.exercisePhrase,
      matchedExerciseId: resolvedExercise.exerciseId,
      matchedExerciseName: resolvedExercise.canonicalName,
      loadValue: draft.loadValue,
      loadUnit: draft.loadUnit,
      createdAt: createdAt,
    );
    return _mapCapturedSet(persistedSet);
  }

  @override
  Future<WorkoutSession> completeSession(
    WorkoutSession session,
    DateTime endedAt,
  ) async {
    final persistedSession = await _database.completeSession(
      session.id,
      endedAt,
    );
    return _mapSession(persistedSession);
  }

  @override
  Future<void> discardSession(WorkoutSession session) async {
    if (!session.isActive) {
      return;
    }

    await _database.deleteSession(session.id);
  }

  @override
  Future<WorkoutSession> createSession(DateTime startedAt) async {
    final persistedSession = await _database.insertSession(startedAt);
    return _mapSession(persistedSession);
  }

  @override
  Future<WorkoutSession?> fetchActiveSession() async {
    final persistedSession = await _database.fetchActiveSession();
    if (persistedSession == null) {
      return null;
    }

    return _mapSession(persistedSession);
  }

  @override
  Future<WorkoutSession?> fetchLastCompletedSession() async {
    final persistedSession = await _database.fetchLastCompletedSession();
    if (persistedSession == null) {
      return null;
    }

    return _mapSession(persistedSession);
  }

  @override
  Future<WorkoutSession?> fetchSessionById(int id) async {
    final persistedSession = await _database.fetchSessionById(id);
    if (persistedSession == null) {
      return null;
    }

    return _mapSession(persistedSession);
  }

  @override
  Future<List<WorkoutSession>> fetchCompletedSessions() async {
    final rows = await _database.fetchCompletedSessions();
    return rows.map(_mapSession).toList(growable: false);
  }

  @override
  Future<List<WorkoutSession>> fetchAllSessions() async {
    final rows = await _database.fetchAllSessions();
    return rows.map(_mapSession).toList(growable: false);
  }

  @override
  Future<List<CapturedSet>> fetchSetsForSession(int sessionId) async {
    final rows = await _database.fetchSessionSets(sessionId);
    return rows.map(_mapCapturedSet).toList();
  }

  WorkoutSession _mapSession(PersistedSession session) {
    return WorkoutSession(
      id: session.id,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
    );
  }

  CapturedSet _mapCapturedSet(PersistedSessionSet sessionSet) {
    return CapturedSet(
      id: sessionSet.id,
      sessionId: sessionSet.sessionId,
      reps: sessionSet.reps,
      exercisePhrase: sessionSet.exercisePhrase,
      matchedExerciseId: sessionSet.matchedExerciseId,
      matchedExerciseName: sessionSet.matchedExerciseName,
      loadValue: sessionSet.loadValue,
      loadUnit: sessionSet.loadUnit,
      createdAt: sessionSet.createdAt,
    );
  }

  Future<ResolvedExerciseMatch?> _resolveExercisePhrase(String phrase) async {
    final activeExercises = await _database.fetchActiveExercises();
    if (activeExercises.isEmpty) {
      return null;
    }

    final aliases = await _database.fetchAliasesForExerciseIds(
      activeExercises.map((exercise) => exercise.id),
    );
    final aliasesByExerciseId = <int, List<String>>{};
    for (final alias in aliases) {
      aliasesByExerciseId
          .putIfAbsent(alias.exerciseId, () => <String>[])
          .add(alias.alias);
    }

    final candidates = activeExercises
        .map(
          (exercise) => ExerciseResolutionCandidate(
            id: exercise.id,
            name: exercise.name,
            aliases: aliasesByExerciseId[exercise.id] ?? const <String>[],
          ),
        )
        .toList(growable: false);

    return _exercisePhraseMatcher.match(phrase, candidates);
  }
}
