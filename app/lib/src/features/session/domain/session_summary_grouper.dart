import 'captured_set.dart';
import 'grouped_session_set.dart';

class SessionSummaryGrouper {
  const SessionSummaryGrouper();

  List<GroupedSessionSet> group(List<CapturedSet> capturedSets) {
    final groups = <_GroupKey, GroupedSessionSet>{};
    final orderedKeys = <_GroupKey>[];

    for (final capturedSet in capturedSets) {
      if (!capturedSet.hasLoad) {
        continue;
      }

      final key = _GroupKey(
        exerciseKey: capturedSet.matchedExerciseId?.toString() ??
            capturedSet.displayExerciseName.toLowerCase(),
        exerciseName: capturedSet.displayExerciseName,
        reps: capturedSet.reps,
        loadValue: capturedSet.loadValue!,
        loadUnit: capturedSet.loadUnit!,
      );

      final existing = groups[key];
      if (existing == null) {
        orderedKeys.add(key);
        groups[key] = GroupedSessionSet(
          exerciseName: key.exerciseName,
          reps: key.reps,
          loadValue: key.loadValue,
          loadUnit: key.loadUnit,
          count: 1,
        );
        continue;
      }

      groups[key] = GroupedSessionSet(
        exerciseName: existing.exerciseName,
        reps: existing.reps,
        loadValue: existing.loadValue,
        loadUnit: existing.loadUnit,
        count: existing.count + 1,
      );
    }

    return orderedKeys.map((key) => groups[key]!).toList(growable: false);
  }
}

class _GroupKey {
  const _GroupKey({
    required this.exerciseKey,
    required this.exerciseName,
    required this.reps,
    required this.loadValue,
    required this.loadUnit,
  });

  final String exerciseKey;
  final String exerciseName;
  final int reps;
  final double loadValue;
  final String loadUnit;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _GroupKey &&
        other.exerciseKey == exerciseKey &&
        other.reps == reps &&
        other.loadValue == loadValue &&
        other.loadUnit == loadUnit;
  }

  @override
  int get hashCode => Object.hash(exerciseKey, reps, loadValue, loadUnit);
}
