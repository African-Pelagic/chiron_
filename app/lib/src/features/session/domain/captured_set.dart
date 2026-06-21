class CapturedSet {
  const CapturedSet({
    required this.id,
    required this.sessionId,
    required this.reps,
    required this.exercisePhrase,
    required this.createdAt,
    this.matchedExerciseId,
    this.matchedExerciseName,
    this.loadValue,
    this.loadUnit,
  });

  final int id;
  final int sessionId;
  final int reps;
  final String exercisePhrase;
  final int? matchedExerciseId;
  final String? matchedExerciseName;
  final double? loadValue;
  final String? loadUnit;
  final DateTime createdAt;

  bool get hasLoad => loadValue != null && loadUnit != null;
  bool get isResolved => matchedExerciseId != null && matchedExerciseName != null;
  String get displayExerciseName => matchedExerciseName ?? exercisePhrase;
}
