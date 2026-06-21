class GroupedSessionSet {
  const GroupedSessionSet({
    required this.exerciseName,
    required this.reps,
    required this.loadValue,
    required this.loadUnit,
    required this.count,
  });

  final String exerciseName;
  final int reps;
  final double loadValue;
  final String loadUnit;
  final int count;
}
