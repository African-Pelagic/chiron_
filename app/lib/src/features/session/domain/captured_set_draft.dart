class CapturedSetDraft {
  const CapturedSetDraft({
    required this.reps,
    required this.exercisePhrase,
    this.loadValue,
    this.loadUnit,
  });

  final int reps;
  final String exercisePhrase;
  final double? loadValue;
  final String? loadUnit;
}
