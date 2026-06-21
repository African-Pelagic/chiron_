import '../../../core/database/app_database.dart';
import '../domain/exercise_csv_import_result.dart';
import '../domain/exercise_definition.dart';
import 'csv_exercise_parser.dart';
import 'exercise_library_repository.dart';

class DriftExerciseLibraryRepository implements ExerciseLibraryRepository {
  DriftExerciseLibraryRepository(
    this._database, {
    CsvExerciseParser? csvExerciseParser,
  }) : _csvExerciseParser = csvExerciseParser ?? const CsvExerciseParser();

  final AppDatabase _database;
  final CsvExerciseParser _csvExerciseParser;

  @override
  Future<void> createExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {
    await _assertNameAvailable(name);
    final created = await _database.insertExercise(
      name: name,
      category: category,
      defaultUnit: defaultUnit,
      isActive: isActive,
    );
    await _database.replaceExerciseAliases(
      exerciseId: created.id,
      aliases: _normalizeAliases(aliases, canonicalName: name),
    );
  }

  @override
  Future<void> setExerciseActive({required int id, required bool isActive}) {
    return _database.setExerciseActive(id: id, isActive: isActive);
  }

  @override
  Future<void> updateExercise({
    required int id,
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {
    await _assertNameAvailable(name, excludingId: id);
    await _database.updateExercise(
      id: id,
      name: name,
      category: category,
      defaultUnit: defaultUnit,
      isActive: isActive,
    );
    await _database.replaceExerciseAliases(
      exerciseId: id,
      aliases: _normalizeAliases(aliases, canonicalName: name),
    );
  }

  @override
  Future<ExerciseCsvImportResult> importExercisesFromCsv(String csvText) async {
    final parsedCsv = _csvExerciseParser.parse(csvText);
    var createdExercises = 0;
    var updatedExercises = 0;
    var addedAliases = 0;

    for (final row in parsedCsv.rows) {
      final existing = await _database.fetchExerciseByNormalizedName(
        row.name.trim().toLowerCase(),
      );

      late final int exerciseId;
      if (existing == null) {
        final created = await _database.insertExercise(
          name: row.name,
          category: row.category,
          defaultUnit: row.defaultUnit,
          isActive: true,
        );
        exerciseId = created.id;
        createdExercises++;
      } else {
        exerciseId = existing.id;

        final shouldUpdate =
            existing.name != row.name ||
            existing.category != row.category ||
            existing.defaultUnit != row.defaultUnit;
        if (shouldUpdate) {
          await _database.updateExercise(
            id: exerciseId,
            name: row.name,
            category: row.category,
            defaultUnit: row.defaultUnit,
            isActive: true,
          );
          updatedExercises++;
        }

        if (!existing.isActive) {
          await _database.setExerciseActive(id: exerciseId, isActive: true);
        }
      }

      for (final alias in row.aliases) {
        final existingAlias = await _database.fetchAliasForExercise(
          exerciseId: exerciseId,
          normalizedAlias: alias.trim().toLowerCase(),
        );
        if (existingAlias != null) {
          continue;
        }

        await _database.insertExerciseAlias(
          exerciseId: exerciseId,
          alias: alias,
        );
        addedAliases++;
      }
    }

    return ExerciseCsvImportResult(
      createdExercises: createdExercises,
      updatedExercises: updatedExercises,
      addedAliases: addedAliases,
      skippedRows: parsedCsv.skippedRows,
    );
  }

  @override
  Stream<List<ExerciseDefinition>> watchExercises() {
    return _database.watchExerciseCatalog().map(
      (rows) => rows
          .map(
            (row) => ExerciseDefinition(
              id: row.id,
              name: row.name,
              category: row.category,
              defaultUnit: row.defaultUnit,
              isActive: row.isActive,
              aliases: row.aliases,
            ),
          )
          .toList(),
    );
  }

  Future<void> _assertNameAvailable(String name, {int? excludingId}) async {
    final existing = await _database.fetchExerciseByNormalizedName(
      name.trim().toLowerCase(),
    );
    if (existing == null) {
      return;
    }

    if (excludingId != null && existing.id == excludingId) {
      return;
    }

    throw const ExerciseNameConflictException();
  }

  List<String> _normalizeAliases(
    List<String> aliases, {
    required String canonicalName,
  }) {
    final normalizedCanonical = canonicalName.trim().toLowerCase();
    final uniqueAliases = <String>{};

    for (final alias in aliases) {
      final trimmed = alias.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      if (trimmed.toLowerCase() == normalizedCanonical) {
        continue;
      }
      uniqueAliases.add(trimmed);
    }

    final sortedAliases = uniqueAliases.toList(growable: false)..sort();
    return sortedAliases;
  }
}

class ExerciseNameConflictException implements Exception {
  const ExerciseNameConflictException();
}
