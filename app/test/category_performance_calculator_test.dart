import 'package:flutter_test/flutter_test.dart';

import 'package:chiron/src/features/exercise_library/domain/exercise_definition.dart';
import 'package:chiron/src/features/session/data/category_performance_calculator.dart';
import 'package:chiron/src/features/session/domain/captured_set.dart';
import 'package:chiron/src/features/session/domain/workout_session.dart';

void main() {
  const calculator = CategoryPerformanceCalculator();

  test('builds weekly average of exercise-level max loads by category', () {
    final series = calculator.buildWeeklyAverageMaxSeries(
      exercises: const <ExerciseDefinition>[
        ExerciseDefinition(
          id: 1,
          name: 'Bench Press',
          category: 'push',
          defaultUnit: 'kg',
          isActive: true,
          aliases: <String>[],
        ),
        ExerciseDefinition(
          id: 2,
          name: 'Dips',
          category: 'push',
          defaultUnit: 'kg',
          isActive: true,
          aliases: <String>[],
        ),
        ExerciseDefinition(
          id: 3,
          name: 'Pull Up',
          category: 'pull',
          defaultUnit: 'kg',
          isActive: true,
          aliases: <String>[],
        ),
      ],
      records: <SessionPerformanceRecord>[
        SessionPerformanceRecord(
          session: WorkoutSession(
            id: 1,
            startedAt: DateTime(2026, 6, 1),
            endedAt: DateTime(2026, 6, 1, 1),
          ),
          sets: <CapturedSet>[
            CapturedSet(
              id: 1,
              sessionId: 1,
              reps: 5,
              exercisePhrase: 'bench press',
              matchedExerciseId: 1,
              matchedExerciseName: 'Bench Press',
              loadValue: 100,
              loadUnit: 'kg',
              createdAt: DateTime(2026, 6, 1, 9),
            ),
            CapturedSet(
              id: 2,
              sessionId: 1,
              reps: 5,
              exercisePhrase: 'bench press',
              matchedExerciseId: 1,
              matchedExerciseName: 'Bench Press',
              loadValue: 110,
              loadUnit: 'kg',
              createdAt: DateTime(2026, 6, 1, 10),
            ),
            CapturedSet(
              id: 3,
              sessionId: 1,
              reps: 8,
              exercisePhrase: 'weighted dips',
              matchedExerciseId: 2,
              matchedExerciseName: 'Dips',
              loadValue: 30,
              loadUnit: 'kg',
              createdAt: DateTime(2026, 6, 2, 9),
            ),
            CapturedSet(
              id: 4,
              sessionId: 1,
              reps: 5,
              exercisePhrase: 'pullup',
              matchedExerciseId: 3,
              matchedExerciseName: 'Pull Up',
              loadValue: 25,
              loadUnit: 'kg',
              createdAt: DateTime(2026, 6, 2, 9),
            ),
          ],
        ),
      ],
      category: 'push',
      referenceDate: DateTime(2026, 6, 7),
      weekCount: 4,
    );

    expect(series, hasLength(4));
    expect(series.last.averageMaxLoad, 70);
    expect(series.last.weekStart, DateTime(2026, 6, 1));
    expect(series.first.averageMaxLoad, isNull);
  });
}
