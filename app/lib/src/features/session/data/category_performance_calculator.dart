import '../../exercise_library/domain/exercise_definition.dart';
import '../domain/captured_set.dart';
import '../domain/workout_session.dart';

class CategoryPerformanceCalculator {
  const CategoryPerformanceCalculator();

  List<WeeklyCategoryPerformancePoint> buildWeeklyAverageMaxSeries({
    required List<ExerciseDefinition> exercises,
    required List<SessionPerformanceRecord> records,
    required String category,
    required DateTime referenceDate,
    int weekCount = 8,
  }) {
    final categoryExerciseIds = exercises
        .where((exercise) => exercise.category == category)
        .map((exercise) => exercise.id)
        .toSet();

    final currentWeekStart = _startOfWeek(referenceDate);
    final firstWeekStart = currentWeekStart.subtract(
      Duration(days: (weekCount - 1) * 7),
    );
    final maxByWeekAndExercise = <DateTime, Map<int, double>>{};

    for (final record in records) {
      for (final capturedSet in record.sets) {
        final exerciseId = capturedSet.matchedExerciseId;
        final loadValue = capturedSet.loadValue;
        if (exerciseId == null ||
            loadValue == null ||
            !categoryExerciseIds.contains(exerciseId)) {
          continue;
        }

        final weekStart = _startOfWeek(capturedSet.createdAt);
        if (weekStart.isBefore(firstWeekStart) ||
            weekStart.isAfter(currentWeekStart)) {
          continue;
        }

        final maxByExercise = maxByWeekAndExercise.putIfAbsent(
          weekStart,
          () => <int, double>{},
        );
        final currentMax = maxByExercise[exerciseId];
        if (currentMax == null || loadValue > currentMax) {
          maxByExercise[exerciseId] = loadValue;
        }
      }
    }

    return List<WeeklyCategoryPerformancePoint>.generate(weekCount, (index) {
      final weekStart = firstWeekStart.add(Duration(days: index * 7));
      final weekExerciseMaxes = maxByWeekAndExercise[weekStart];
      final averageMaxLoad =
          weekExerciseMaxes == null || weekExerciseMaxes.isEmpty
          ? null
          : weekExerciseMaxes.values.reduce((left, right) => left + right) /
                weekExerciseMaxes.length;

      return WeeklyCategoryPerformancePoint(
        weekStart: weekStart,
        averageMaxLoad: averageMaxLoad,
      );
    });
  }

  DateTime _startOfWeek(DateTime dateTime) {
    final local = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final daysFromMonday = local.weekday - DateTime.monday;
    return local.subtract(Duration(days: daysFromMonday));
  }
}

class WeeklyCategoryPerformancePoint {
  const WeeklyCategoryPerformancePoint({
    required this.weekStart,
    required this.averageMaxLoad,
  });

  final DateTime weekStart;
  final double? averageMaxLoad;
}

class SessionPerformanceRecord {
  const SessionPerformanceRecord({required this.session, required this.sets});

  final WorkoutSession session;
  final List<CapturedSet> sets;
}
