import 'package:chiron/src/features/session/domain/captured_set.dart';
import 'package:chiron/src/features/session/domain/session_summary_grouper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const grouper = SessionSummaryGrouper();

  test('groups repeated identical sets while preserving first-seen order', () {
    final groups = grouper.group(<CapturedSet>[
      _capturedSet(
        id: 1,
        matchedExerciseId: 1,
        matchedExerciseName: 'Dips',
        reps: 12,
        loadValue: 30,
      ),
      _capturedSet(
        id: 2,
        matchedExerciseId: 2,
        matchedExerciseName: 'Pull Up',
        reps: 8,
        loadValue: 20,
      ),
      _capturedSet(
        id: 3,
        matchedExerciseId: 1,
        matchedExerciseName: 'Dips',
        reps: 12,
        loadValue: 30,
      ),
    ]);

    expect(groups, hasLength(2));
    expect(groups[0].exerciseName, 'Dips');
    expect(groups[0].count, 2);
    expect(groups[1].exerciseName, 'Pull Up');
    expect(groups[1].count, 1);
  });

  test('keeps similar exercises or loads in separate groups', () {
    final groups = grouper.group(<CapturedSet>[
      _capturedSet(
        id: 1,
        matchedExerciseId: 1,
        matchedExerciseName: 'Bench Press',
        reps: 5,
        loadValue: 60,
      ),
      _capturedSet(
        id: 2,
        matchedExerciseId: 1,
        matchedExerciseName: 'Bench Press',
        reps: 5,
        loadValue: 62.5,
      ),
      _capturedSet(
        id: 3,
        matchedExerciseId: 3,
        matchedExerciseName: 'Incline Bench Press',
        reps: 5,
        loadValue: 60,
      ),
    ]);

    expect(groups, hasLength(3));
  });
}

CapturedSet _capturedSet({
  required int id,
  required int matchedExerciseId,
  required String matchedExerciseName,
  required int reps,
  required double loadValue,
}) {
  return CapturedSet(
    id: id,
    sessionId: 1,
    reps: reps,
    exercisePhrase: matchedExerciseName.toLowerCase(),
    matchedExerciseId: matchedExerciseId,
    matchedExerciseName: matchedExerciseName,
    loadValue: loadValue,
    loadUnit: 'kg',
    createdAt: DateTime.utc(2026, 6, 21, 12, 0, id),
  );
}
