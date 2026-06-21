import '../domain/captured_set.dart';
import '../domain/captured_set_draft.dart';
import '../domain/workout_session.dart';

abstract class SessionRepository {
  Future<WorkoutSession?> fetchActiveSession();

  Future<WorkoutSession?> fetchLastCompletedSession();

  Future<WorkoutSession?> fetchSessionById(int id);

  Future<List<WorkoutSession>> fetchCompletedSessions();

  Future<List<WorkoutSession>> fetchAllSessions();

  Future<WorkoutSession> createSession(DateTime startedAt);

  Future<WorkoutSession> completeSession(
    WorkoutSession session,
    DateTime endedAt,
  );

  Future<void> discardSession(WorkoutSession session);

  Future<List<CapturedSet>> fetchSetsForSession(int sessionId);

  Future<CapturedSet> addCapturedSet({
    required int sessionId,
    required CapturedSetDraft draft,
    required DateTime createdAt,
  });
}
