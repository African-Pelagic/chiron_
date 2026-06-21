class ExerciseCsvImportResult {
  const ExerciseCsvImportResult({
    required this.createdExercises,
    required this.updatedExercises,
    required this.addedAliases,
    required this.skippedRows,
  });

  final int createdExercises;
  final int updatedExercises;
  final int addedAliases;
  final int skippedRows;
}
