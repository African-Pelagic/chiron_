import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/csv_exercise_parser.dart';
import '../data/drift_exercise_library_repository.dart';
import '../data/exercise_library_repository.dart';
import '../domain/exercise_csv_import_result.dart';
import '../domain/exercise_definition.dart';

class ExerciseLibraryController extends ChangeNotifier {
  ExerciseLibraryController({required this.exerciseLibraryRepository});

  final ExerciseLibraryRepository exerciseLibraryRepository;

  List<ExerciseDefinition> _exercises = const [];
  bool _isHydrated = false;
  bool _isSaving = false;
  String? _errorMessage;
  ExerciseCsvImportResult? _lastImportResult;
  StreamSubscription<List<ExerciseDefinition>>? _subscription;
  Future<void>? _hydrationFuture;

  List<ExerciseDefinition> get activeExercises =>
      _exercises.where((exercise) => exercise.isActive).toList();
  List<ExerciseDefinition> get archivedExercises =>
      _exercises.where((exercise) => !exercise.isActive).toList();
  List<ExerciseDefinition> get exercises => List.unmodifiable(_exercises);
  String? get errorMessage => _errorMessage;
  bool get isHydrated => _isHydrated;
  bool get isSaving => _isSaving;
  ExerciseCsvImportResult? get lastImportResult => _lastImportResult;

  Future<void> hydrate() {
    return _hydrationFuture ??= _hydrate();
  }

  Future<void> createExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) {
    return _runMutation(
      () => exerciseLibraryRepository.createExercise(
        name: name.trim(),
        category: category.trim(),
        defaultUnit: defaultUnit.trim(),
        isActive: isActive,
        aliases: aliases,
      ),
    );
  }

  Future<void> updateExercise({
    required int id,
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) {
    return _runMutation(
      () => exerciseLibraryRepository.updateExercise(
        id: id,
        name: name.trim(),
        category: category.trim(),
        defaultUnit: defaultUnit.trim(),
        isActive: isActive,
        aliases: aliases,
      ),
    );
  }

  Future<void> setExerciseActive({required int id, required bool isActive}) {
    return _runMutation(
      () => exerciseLibraryRepository.setExerciseActive(
        id: id,
        isActive: isActive,
      ),
    );
  }

  Future<void> importCsv(String csvText) {
    return _runMutation(() async {
      _lastImportResult = await exerciseLibraryRepository
          .importExercisesFromCsv(csvText);
    });
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  Future<void> _hydrate() async {
    _subscription = exerciseLibraryRepository.watchExercises().listen((items) {
      _exercises = items;
      _isHydrated = true;
      notifyListeners();
    });
  }

  Future<void> _runMutation(Future<void> Function() action) async {
    if (_isSaving) {
      return;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
    } on ExerciseNameConflictException {
      _errorMessage = 'An exercise with that name already exists.';
    } on ExerciseCsvFormatException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
