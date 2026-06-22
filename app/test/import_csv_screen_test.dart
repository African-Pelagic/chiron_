import 'dart:async';

import 'package:chiron/src/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:chiron/src/features/exercise_library/application/exercise_library_controller.dart';
import 'package:chiron/src/features/exercise_library/data/csv_file_access.dart';
import 'package:chiron/src/features/exercise_library/data/exercise_library_repository.dart';
import 'package:chiron/src/features/exercise_library/domain/exercise_csv_import_result.dart';
import 'package:chiron/src/features/exercise_library/domain/exercise_definition.dart';
import 'package:chiron/src/features/exercise_library/presentation/import_csv_screen.dart';

void main() {
  late _FakeImportRepository repository;
  late ExerciseLibraryController controller;
  late _FakeCsvFileAccess csvFileAccess;

  setUp(() {
    repository = _FakeImportRepository();
    controller = ExerciseLibraryController(
      exerciseLibraryRepository: repository,
    );
    csvFileAccess = _FakeCsvFileAccess();
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('imports pasted csv and shows a summary', (
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
        home: ImportCsvScreen(
          exerciseLibraryController: controller,
          csvFileAccess: csvFileAccess,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText),
      'name,alias_1,category,default_unit\nDips,weighted dips,push,kg',
    );
    await tester.tap(find.text('Import CSV'));
    await tester.pumpAndSettle();

    expect(find.text('Import summary'), findsOneWidget);
    expect(find.text('Exercises created'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(repository.lastImportedCsv, contains('Dips'));
  });
}

class _FakeImportRepository implements ExerciseLibraryRepository {
  String? lastImportedCsv;

  @override
  Future<void> createExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {}

  @override
  Future<ExerciseCsvImportResult> importExercisesFromCsv(String csvText) async {
    lastImportedCsv = csvText;
    return const ExerciseCsvImportResult(
      createdExercises: 1,
      updatedExercises: 0,
      addedAliases: 1,
      skippedRows: 0,
    );
  }

  @override
  Future<void> setExerciseActive({
    required int id,
    required bool isActive,
  }) async {}

  @override
  Future<void> updateExercise({
    required int id,
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
    required List<String> aliases,
  }) async {}

  @override
  Stream<List<ExerciseDefinition>> watchExercises() {
    return Stream<List<ExerciseDefinition>>.value(const []);
  }
}

class _FakeCsvFileAccess implements CsvFileAccess {
  @override
  Future<String?> pickCsvText() async => null;

  @override
  Future<String?> saveSchemaCsv(String csvText) async => '/tmp/schema.csv';

  @override
  Future<String?> saveSetExportCsv(String csvText) async =>
      '/tmp/sets-export.csv';
}
