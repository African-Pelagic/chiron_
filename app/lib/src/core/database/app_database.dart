import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class PersistedSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime().nullable()();
}

class PersistedSessionSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(PersistedSessions, #id)();

  IntColumn get reps => integer()();

  TextColumn get exercisePhrase => text()();

  IntColumn get matchedExerciseId =>
      integer().nullable().references(PersistedExercises, #id)();

  TextColumn get matchedExerciseName => text().nullable()();

  RealColumn get loadValue => real().nullable()();

  TextColumn get loadUnit => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

class PersistedExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get category => text()();

  TextColumn get defaultUnit => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class PersistedExerciseAliases extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get exerciseId => integer().references(PersistedExercises, #id)();

  TextColumn get alias => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {exerciseId, alias},
  ];
}

@DriftDatabase(
  tables: [
    PersistedSessions,
    PersistedSessionSets,
    PersistedExercises,
    PersistedExerciseAliases,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'chiron_app'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(persistedExercises);
      }
      if (from < 3) {
        await migrator.createTable(persistedExerciseAliases);
      }
      if (from < 4) {
        await migrator.createTable(persistedSessionSets);
      }
      if (from < 5) {
        await migrator.addColumn(
          persistedSessionSets,
          persistedSessionSets.matchedExerciseId,
        );
        await migrator.addColumn(
          persistedSessionSets,
          persistedSessionSets.matchedExerciseName,
        );
      }
    },
  );

  Future<PersistedSession?> fetchActiveSession() {
    return (select(persistedSessions)
          ..where((table) => table.endedAt.isNull())
          ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<PersistedSession?> fetchLastCompletedSession() {
    return (select(persistedSessions)
          ..where((table) => table.endedAt.isNotNull())
          ..orderBy([(table) => OrderingTerm.desc(table.endedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<PersistedSession?> fetchSessionById(int id) {
    return (select(
      persistedSessions,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<PersistedSession>> fetchCompletedSessions() {
    return (select(persistedSessions)
          ..where((table) => table.endedAt.isNotNull())
          ..orderBy([
            (table) => OrderingTerm.desc(table.endedAt),
            (table) => OrderingTerm.desc(table.id),
          ]))
        .get();
  }

  Future<List<PersistedSession>> fetchAllSessions() {
    return (select(persistedSessions)
          ..orderBy([
            (table) => OrderingTerm.asc(table.startedAt),
            (table) => OrderingTerm.asc(table.id),
          ]))
        .get();
  }

  Future<PersistedSession> insertSession(DateTime startedAt) async {
    final id = await into(
      persistedSessions,
    ).insert(PersistedSessionsCompanion.insert(startedAt: startedAt));

    return (select(
      persistedSessions,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<PersistedSession> completeSession(int id, DateTime endedAt) async {
    await (update(persistedSessions)..where((table) => table.id.equals(id)))
        .write(PersistedSessionsCompanion(endedAt: Value(endedAt)));

    return (select(
      persistedSessions,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<void> deleteSession(int id) async {
    await transaction(() async {
      await (delete(
        persistedSessionSets,
      )..where((table) => table.sessionId.equals(id))).go();
      await (delete(persistedSessions)..where((table) => table.id.equals(id)))
          .go();
    });
  }

  Future<List<PersistedSessionSet>> fetchSessionSets(int sessionId) {
    return (select(persistedSessionSets)
          ..where((table) => table.sessionId.equals(sessionId))
          ..orderBy([
            (table) => OrderingTerm.asc(table.createdAt),
            (table) => OrderingTerm.asc(table.id),
          ]))
        .get();
  }

  Future<PersistedSessionSet> insertSessionSet({
    required int sessionId,
    required int reps,
    required String exercisePhrase,
    required int? matchedExerciseId,
    required String? matchedExerciseName,
    required double? loadValue,
    required String? loadUnit,
    required DateTime createdAt,
  }) async {
    final id = await into(persistedSessionSets).insert(
      PersistedSessionSetsCompanion.insert(
        sessionId: sessionId,
        reps: reps,
        exercisePhrase: exercisePhrase,
        matchedExerciseId: Value(matchedExerciseId),
        matchedExerciseName: Value(matchedExerciseName),
        loadValue: Value(loadValue),
        loadUnit: Value(loadUnit),
        createdAt: createdAt,
      ),
    );

    return (select(
      persistedSessionSets,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Stream<List<ExerciseCatalogRecord>> watchExerciseCatalog() {
    final query = select(persistedExercises).join([
      leftOuterJoin(
        persistedExerciseAliases,
        persistedExerciseAliases.exerciseId.equalsExp(persistedExercises.id),
      ),
    ])
      ..orderBy([
        OrderingTerm.desc(persistedExercises.isActive),
        OrderingTerm.asc(persistedExercises.name),
        OrderingTerm.asc(persistedExerciseAliases.alias),
      ]);

    return query.watch().map(_mapExerciseCatalogRows);
  }

  Future<List<PersistedExercise>> fetchActiveExercises() {
    return (select(persistedExercises)
          ..where((table) => table.isActive.equals(true))
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .get();
  }

  Future<List<PersistedExerciseAliase>> fetchAliasesForExerciseIds(
    Iterable<int> exerciseIds,
  ) {
    final ids = exerciseIds.toList(growable: false);
    if (ids.isEmpty) {
      return Future<List<PersistedExerciseAliase>>.value(
        const <PersistedExerciseAliase>[],
      );
    }

    return (select(persistedExerciseAliases)
          ..where((table) => table.exerciseId.isIn(ids))
          ..orderBy([(table) => OrderingTerm.asc(table.alias)]))
        .get();
  }

  Future<PersistedExercise?> fetchExerciseByNormalizedName(
    String normalizedName,
  ) {
    return (select(persistedExercises)
          ..where(
            (table) => table.name.lower().equals(normalizedName.toLowerCase()),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<PersistedExerciseAliase?> fetchAliasForExercise({
    required int exerciseId,
    required String normalizedAlias,
  }) {
    return (select(persistedExerciseAliases)
          ..where((table) => table.exerciseId.equals(exerciseId))
          ..where(
            (table) =>
                table.alias.lower().equals(normalizedAlias.toLowerCase()),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<PersistedExercise> insertExercise({
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
  }) async {
    final id = await into(persistedExercises).insert(
      PersistedExercisesCompanion.insert(
        name: name,
        category: category,
        defaultUnit: defaultUnit,
        isActive: Value(isActive),
      ),
    );

    return (select(
      persistedExercises,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<void> updateExercise({
    required int id,
    required String name,
    required String category,
    required String defaultUnit,
    required bool isActive,
  }) {
    return (update(
      persistedExercises,
    )..where((table) => table.id.equals(id))).write(
      PersistedExercisesCompanion(
        name: Value(name),
        category: Value(category),
        defaultUnit: Value(defaultUnit),
        isActive: Value(isActive),
      ),
    );
  }

  Future<void> setExerciseActive({required int id, required bool isActive}) {
    return (update(persistedExercises)..where((table) => table.id.equals(id)))
        .write(PersistedExercisesCompanion(isActive: Value(isActive)));
  }

  Future<void> insertExerciseAlias({
    required int exerciseId,
    required String alias,
  }) {
    return into(persistedExerciseAliases).insert(
      PersistedExerciseAliasesCompanion.insert(
        exerciseId: exerciseId,
        alias: alias,
      ),
    );
  }

  Future<void> replaceExerciseAliases({
    required int exerciseId,
    required List<String> aliases,
  }) async {
    await transaction(() async {
      await (delete(
        persistedExerciseAliases,
      )..where((table) => table.exerciseId.equals(exerciseId))).go();

      for (final alias in aliases) {
        await into(persistedExerciseAliases).insert(
          PersistedExerciseAliasesCompanion.insert(
            exerciseId: exerciseId,
            alias: alias,
          ),
        );
      }
    });
  }

  List<ExerciseCatalogRecord> _mapExerciseCatalogRows(List<TypedResult> rows) {
    final recordsById = <int, _ExerciseCatalogRecordBuilder>{};

    for (final row in rows) {
      final exercise = row.readTable(persistedExercises);
      final alias = row.readTableOrNull(persistedExerciseAliases);
      final builder = recordsById.putIfAbsent(
        exercise.id,
        () => _ExerciseCatalogRecordBuilder(
          id: exercise.id,
          name: exercise.name,
          category: exercise.category,
          defaultUnit: exercise.defaultUnit,
          isActive: exercise.isActive,
        ),
      );

      if (alias != null && alias.alias.trim().isNotEmpty) {
        builder.aliases.add(alias.alias);
      }
    }

    return recordsById.values
        .map(
          (builder) => ExerciseCatalogRecord(
            id: builder.id,
            name: builder.name,
            category: builder.category,
            defaultUnit: builder.defaultUnit,
            isActive: builder.isActive,
            aliases: List<String>.unmodifiable(builder.aliases),
          ),
        )
        .toList(growable: false);
  }
}

class ExerciseCatalogRecord {
  const ExerciseCatalogRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultUnit,
    required this.isActive,
    required this.aliases,
  });

  final int id;
  final String name;
  final String category;
  final String defaultUnit;
  final bool isActive;
  final List<String> aliases;
}

class _ExerciseCatalogRecordBuilder {
  _ExerciseCatalogRecordBuilder({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultUnit,
    required this.isActive,
  });

  final int id;
  final String name;
  final String category;
  final String defaultUnit;
  final bool isActive;
  final Set<String> aliases = <String>{};
}
