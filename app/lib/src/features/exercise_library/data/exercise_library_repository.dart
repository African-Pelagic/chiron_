import '../domain/exercise_csv_import_result.dart';
import '../domain/exercise_definition.dart';

abstract class ExerciseLibraryRepository {
  Stream<List<ExerciseDefinition>> watchExercises();

  Future<void> createExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  });

  Future<void> updateExercise({
    required int id,
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  });

  Future<void> setExerciseActive({required int id, required bool isActive});

  Future<ExerciseCsvImportResult> importExercisesFromCsv(String csvText);
}
