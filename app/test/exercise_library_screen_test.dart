import 'dart:async';

import 'package:chiron/src/app/router.dart';
import 'package:chiron/src/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:chiron/src/features/exercise_library/application/exercise_library_controller.dart';
import 'package:chiron/src/features/exercise_library/data/exercise_library_repository.dart';
import 'package:chiron/src/features/exercise_library/domain/exercise_csv_import_result.dart';
import 'package:chiron/src/features/exercise_library/domain/exercise_definition.dart';
import 'package:chiron/src/features/exercise_library/presentation/exercise_editor_screen.dart';
import 'package:chiron/src/features/exercise_library/presentation/exercise_library_screen.dart';

void main() {
  late _FakeExerciseLibraryRepository repository;
  late ExerciseLibraryController controller;

  setUp(() {
    repository = _FakeExerciseLibraryRepository();
    controller = ExerciseLibraryController(
      exerciseLibraryRepository: repository,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('adds an exercise through the library screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    unawaited(controller.hydrate());

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMaterialTheme(),
        builder: (context, child) {
          return ShadTheme(data: buildShadTheme(), child: child!);
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutePath.exerciseEditor) {
            return MaterialPageRoute<void>(
              builder: (_) => ExerciseEditorScreen(
                exerciseLibraryController: controller,
              ),
            );
          }

          return null;
        },
        home: ExerciseLibraryScreen(exerciseLibraryController: controller),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Exercise').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(0), 'Dips');
    await tester.enterText(find.byType(EditableText).at(1), 'push');
    await tester.enterText(find.byType(EditableText).at(2), 'kg');
    await tester.enterText(
      find.byType(EditableText).at(3),
      'weighted dips, bar dips',
    );

    await tester.tap(find.text('Create Exercise'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Dips'), findsWidgets);
    expect(find.textContaining('Category: push'), findsOneWidget);
    expect(find.textContaining('Unit: kg'), findsOneWidget);
    expect(find.textContaining('weighted dips'), findsOneWidget);
  });

  testWidgets('edits and archives an exercise through the editor screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await repository.createExercise(
      name: 'Bench Press',
      category: 'push',
      defaultUnit: 'kg',
      isActive: true,
      aliases: const <String>['barbell bench'],
    );
    unawaited(controller.hydrate());

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMaterialTheme(),
        builder: (context, child) {
          return ShadTheme(data: buildShadTheme(), child: child!);
        },
        home: ExerciseEditorScreen(
          exerciseLibraryController: controller,
          exercise: const ExerciseDefinition(
            id: 1,
            name: 'Bench Press',
            category: 'push',
            defaultUnit: 'kg',
            isActive: true,
            aliases: <String>['barbell bench'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(1), 'chest');
    await tester.enterText(
      find.byType(EditableText).at(3),
      'barbell bench, competition bench',
    );
    await tester.tap(find.byType(ShadSwitch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Exercise'));
    await tester.pumpAndSettle();

    final updatedExercise = repository.exercises.single;
    expect(updatedExercise.category, 'chest');
    expect(updatedExercise.isActive, isFalse);
    expect(updatedExercise.aliases, contains('competition bench'));
  });
}

class _FakeExerciseLibraryRepository implements ExerciseLibraryRepository {
  final _controller = StreamController<List<ExerciseDefinition>>.broadcast();
  final List<ExerciseDefinition> _exercises = <ExerciseDefinition>[];
  int _nextId = 1;

  List<ExerciseDefinition> get exercises => List<ExerciseDefinition>.unmodifiable(
    _exercises,
  );

  @override
  Future<void> createExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {
    _assertUniqueName(name);
    _exercises.add(
      ExerciseDefinition(
        id: _nextId++,
        name: name,
        category: category,
        defaultUnit: defaultUnit,
        isActive: isActive,
        aliases: List<String>.from(aliases),
      ),
    );
    _emit();
  }

  @override
  Future<ExerciseCsvImportResult> importExercisesFromCsv(String csvText) async {
    return const ExerciseCsvImportResult(
      createdExercises: 0,
      updatedExercises: 0,
      addedAliases: 0,
      skippedRows: 0,
    );
  }

  @override
  Future<void> setExerciseActive({
    required int id,
    required bool isActive,
  }) async {
    final index = _exercises.indexWhere((exercise) => exercise.id == id);
    final current = _exercises[index];
    _exercises[index] = ExerciseDefinition(
      id: current.id,
      name: current.name,
      category: current.category,
      defaultUnit: current.defaultUnit,
      isActive: isActive,
      aliases: current.aliases,
    );
    _emit();
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
    _assertUniqueName(name, excludingId: id);
    final index = _exercises.indexWhere((exercise) => exercise.id == id);
    _exercises[index] = ExerciseDefinition(
      id: id,
      name: name,
      category: category,
      defaultUnit: defaultUnit,
      isActive: isActive,
      aliases: List<String>.from(aliases),
    );
    _emit();
  }

  @override
  Stream<List<ExerciseDefinition>> watchExercises() {
    Future<void>.microtask(_emit);
    return _controller.stream;
  }

  void _assertUniqueName(String name, {int? excludingId}) {
    final normalized = name.trim().toLowerCase();
    for (final exercise in _exercises) {
      if (exercise.name.trim().toLowerCase() != normalized) {
        continue;
      }

      if (excludingId != null && exercise.id == excludingId) {
        continue;
      }

      throw Exception('duplicate');
    }
  }

  void _emit() {
    final sorted = List<ExerciseDefinition>.from(_exercises)
      ..sort((left, right) {
        if (left.isActive != right.isActive) {
          return left.isActive ? -1 : 1;
        }

        return left.name.compareTo(right.name);
      });
    _controller.add(sorted);
  }
}
