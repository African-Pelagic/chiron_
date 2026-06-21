// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PersistedSessionsTable extends PersistedSessions
    with TableInfo<$PersistedSessionsTable, PersistedSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersistedSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, endedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persisted_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersistedSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersistedSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersistedSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $PersistedSessionsTable createAlias(String alias) {
    return $PersistedSessionsTable(attachedDatabase, alias);
  }
}

class PersistedSession extends DataClass
    implements Insertable<PersistedSession> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  const PersistedSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  PersistedSessionsCompanion toCompanion(bool nullToAbsent) {
    return PersistedSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory PersistedSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersistedSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  PersistedSession copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
  }) => PersistedSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  PersistedSession copyWithCompanion(PersistedSessionsCompanion data) {
    return PersistedSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersistedSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersistedSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class PersistedSessionsCompanion extends UpdateCompanion<PersistedSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  const PersistedSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
  });
  PersistedSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
  }) : startedAt = Value(startedAt);
  static Insertable<PersistedSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
    });
  }

  PersistedSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
  }) {
    return PersistedSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersistedSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }
}

class $PersistedExercisesTable extends PersistedExercises
    with TableInfo<$PersistedExercisesTable, PersistedExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersistedExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultUnitMeta = const VerificationMeta(
    'defaultUnit',
  );
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
    'default_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    defaultUnit,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persisted_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersistedExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('default_unit')) {
      context.handle(
        _defaultUnitMeta,
        defaultUnit.isAcceptableOrUnknown(
          data['default_unit']!,
          _defaultUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultUnitMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersistedExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersistedExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      defaultUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_unit'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $PersistedExercisesTable createAlias(String alias) {
    return $PersistedExercisesTable(attachedDatabase, alias);
  }
}

class PersistedExercise extends DataClass
    implements Insertable<PersistedExercise> {
  final int id;
  final String name;
  final String category;
  final String defaultUnit;
  final bool isActive;
  const PersistedExercise({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultUnit,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['default_unit'] = Variable<String>(defaultUnit);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PersistedExercisesCompanion toCompanion(bool nullToAbsent) {
    return PersistedExercisesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      defaultUnit: Value(defaultUnit),
      isActive: Value(isActive),
    );
  }

  factory PersistedExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersistedExercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PersistedExercise copyWith({
    int? id,
    String? name,
    String? category,
    String? defaultUnit,
    bool? isActive,
  }) => PersistedExercise(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    defaultUnit: defaultUnit ?? this.defaultUnit,
    isActive: isActive ?? this.isActive,
  );
  PersistedExercise copyWithCompanion(PersistedExercisesCompanion data) {
    return PersistedExercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      defaultUnit: data.defaultUnit.present
          ? data.defaultUnit.value
          : this.defaultUnit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersistedExercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, defaultUnit, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersistedExercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.defaultUnit == this.defaultUnit &&
          other.isActive == this.isActive);
}

class PersistedExercisesCompanion extends UpdateCompanion<PersistedExercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> defaultUnit;
  final Value<bool> isActive;
  const PersistedExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PersistedExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required String defaultUnit,
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       defaultUnit = Value(defaultUnit);
  static Insertable<PersistedExercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? defaultUnit,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PersistedExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? defaultUnit,
    Value<bool>? isActive,
  }) {
    return PersistedExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersistedExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $PersistedSessionSetsTable extends PersistedSessionSets
    with TableInfo<$PersistedSessionSetsTable, PersistedSessionSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersistedSessionSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persisted_sessions (id)',
    ),
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exercisePhraseMeta = const VerificationMeta(
    'exercisePhrase',
  );
  @override
  late final GeneratedColumn<String> exercisePhrase = GeneratedColumn<String>(
    'exercise_phrase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _matchedExerciseIdMeta = const VerificationMeta(
    'matchedExerciseId',
  );
  @override
  late final GeneratedColumn<int> matchedExerciseId = GeneratedColumn<int>(
    'matched_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persisted_exercises (id)',
    ),
  );
  static const VerificationMeta _matchedExerciseNameMeta =
      const VerificationMeta('matchedExerciseName');
  @override
  late final GeneratedColumn<String> matchedExerciseName =
      GeneratedColumn<String>(
        'matched_exercise_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _loadValueMeta = const VerificationMeta(
    'loadValue',
  );
  @override
  late final GeneratedColumn<double> loadValue = GeneratedColumn<double>(
    'load_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadUnitMeta = const VerificationMeta(
    'loadUnit',
  );
  @override
  late final GeneratedColumn<String> loadUnit = GeneratedColumn<String>(
    'load_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    reps,
    exercisePhrase,
    matchedExerciseId,
    matchedExerciseName,
    loadValue,
    loadUnit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persisted_session_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersistedSessionSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('exercise_phrase')) {
      context.handle(
        _exercisePhraseMeta,
        exercisePhrase.isAcceptableOrUnknown(
          data['exercise_phrase']!,
          _exercisePhraseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercisePhraseMeta);
    }
    if (data.containsKey('matched_exercise_id')) {
      context.handle(
        _matchedExerciseIdMeta,
        matchedExerciseId.isAcceptableOrUnknown(
          data['matched_exercise_id']!,
          _matchedExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('matched_exercise_name')) {
      context.handle(
        _matchedExerciseNameMeta,
        matchedExerciseName.isAcceptableOrUnknown(
          data['matched_exercise_name']!,
          _matchedExerciseNameMeta,
        ),
      );
    }
    if (data.containsKey('load_value')) {
      context.handle(
        _loadValueMeta,
        loadValue.isAcceptableOrUnknown(data['load_value']!, _loadValueMeta),
      );
    }
    if (data.containsKey('load_unit')) {
      context.handle(
        _loadUnitMeta,
        loadUnit.isAcceptableOrUnknown(data['load_unit']!, _loadUnitMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersistedSessionSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersistedSessionSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      exercisePhrase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_phrase'],
      )!,
      matchedExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}matched_exercise_id'],
      ),
      matchedExerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matched_exercise_name'],
      ),
      loadValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_value'],
      ),
      loadUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}load_unit'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PersistedSessionSetsTable createAlias(String alias) {
    return $PersistedSessionSetsTable(attachedDatabase, alias);
  }
}

class PersistedSessionSet extends DataClass
    implements Insertable<PersistedSessionSet> {
  final int id;
  final int sessionId;
  final int reps;
  final String exercisePhrase;
  final int? matchedExerciseId;
  final String? matchedExerciseName;
  final double? loadValue;
  final String? loadUnit;
  final DateTime createdAt;
  const PersistedSessionSet({
    required this.id,
    required this.sessionId,
    required this.reps,
    required this.exercisePhrase,
    this.matchedExerciseId,
    this.matchedExerciseName,
    this.loadValue,
    this.loadUnit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['reps'] = Variable<int>(reps);
    map['exercise_phrase'] = Variable<String>(exercisePhrase);
    if (!nullToAbsent || matchedExerciseId != null) {
      map['matched_exercise_id'] = Variable<int>(matchedExerciseId);
    }
    if (!nullToAbsent || matchedExerciseName != null) {
      map['matched_exercise_name'] = Variable<String>(matchedExerciseName);
    }
    if (!nullToAbsent || loadValue != null) {
      map['load_value'] = Variable<double>(loadValue);
    }
    if (!nullToAbsent || loadUnit != null) {
      map['load_unit'] = Variable<String>(loadUnit);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PersistedSessionSetsCompanion toCompanion(bool nullToAbsent) {
    return PersistedSessionSetsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      reps: Value(reps),
      exercisePhrase: Value(exercisePhrase),
      matchedExerciseId: matchedExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(matchedExerciseId),
      matchedExerciseName: matchedExerciseName == null && nullToAbsent
          ? const Value.absent()
          : Value(matchedExerciseName),
      loadValue: loadValue == null && nullToAbsent
          ? const Value.absent()
          : Value(loadValue),
      loadUnit: loadUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(loadUnit),
      createdAt: Value(createdAt),
    );
  }

  factory PersistedSessionSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersistedSessionSet(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      reps: serializer.fromJson<int>(json['reps']),
      exercisePhrase: serializer.fromJson<String>(json['exercisePhrase']),
      matchedExerciseId: serializer.fromJson<int?>(json['matchedExerciseId']),
      matchedExerciseName: serializer.fromJson<String?>(
        json['matchedExerciseName'],
      ),
      loadValue: serializer.fromJson<double?>(json['loadValue']),
      loadUnit: serializer.fromJson<String?>(json['loadUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'reps': serializer.toJson<int>(reps),
      'exercisePhrase': serializer.toJson<String>(exercisePhrase),
      'matchedExerciseId': serializer.toJson<int?>(matchedExerciseId),
      'matchedExerciseName': serializer.toJson<String?>(matchedExerciseName),
      'loadValue': serializer.toJson<double?>(loadValue),
      'loadUnit': serializer.toJson<String?>(loadUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PersistedSessionSet copyWith({
    int? id,
    int? sessionId,
    int? reps,
    String? exercisePhrase,
    Value<int?> matchedExerciseId = const Value.absent(),
    Value<String?> matchedExerciseName = const Value.absent(),
    Value<double?> loadValue = const Value.absent(),
    Value<String?> loadUnit = const Value.absent(),
    DateTime? createdAt,
  }) => PersistedSessionSet(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    reps: reps ?? this.reps,
    exercisePhrase: exercisePhrase ?? this.exercisePhrase,
    matchedExerciseId: matchedExerciseId.present
        ? matchedExerciseId.value
        : this.matchedExerciseId,
    matchedExerciseName: matchedExerciseName.present
        ? matchedExerciseName.value
        : this.matchedExerciseName,
    loadValue: loadValue.present ? loadValue.value : this.loadValue,
    loadUnit: loadUnit.present ? loadUnit.value : this.loadUnit,
    createdAt: createdAt ?? this.createdAt,
  );
  PersistedSessionSet copyWithCompanion(PersistedSessionSetsCompanion data) {
    return PersistedSessionSet(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      reps: data.reps.present ? data.reps.value : this.reps,
      exercisePhrase: data.exercisePhrase.present
          ? data.exercisePhrase.value
          : this.exercisePhrase,
      matchedExerciseId: data.matchedExerciseId.present
          ? data.matchedExerciseId.value
          : this.matchedExerciseId,
      matchedExerciseName: data.matchedExerciseName.present
          ? data.matchedExerciseName.value
          : this.matchedExerciseName,
      loadValue: data.loadValue.present ? data.loadValue.value : this.loadValue,
      loadUnit: data.loadUnit.present ? data.loadUnit.value : this.loadUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersistedSessionSet(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('reps: $reps, ')
          ..write('exercisePhrase: $exercisePhrase, ')
          ..write('matchedExerciseId: $matchedExerciseId, ')
          ..write('matchedExerciseName: $matchedExerciseName, ')
          ..write('loadValue: $loadValue, ')
          ..write('loadUnit: $loadUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    reps,
    exercisePhrase,
    matchedExerciseId,
    matchedExerciseName,
    loadValue,
    loadUnit,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersistedSessionSet &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.reps == this.reps &&
          other.exercisePhrase == this.exercisePhrase &&
          other.matchedExerciseId == this.matchedExerciseId &&
          other.matchedExerciseName == this.matchedExerciseName &&
          other.loadValue == this.loadValue &&
          other.loadUnit == this.loadUnit &&
          other.createdAt == this.createdAt);
}

class PersistedSessionSetsCompanion
    extends UpdateCompanion<PersistedSessionSet> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> reps;
  final Value<String> exercisePhrase;
  final Value<int?> matchedExerciseId;
  final Value<String?> matchedExerciseName;
  final Value<double?> loadValue;
  final Value<String?> loadUnit;
  final Value<DateTime> createdAt;
  const PersistedSessionSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.reps = const Value.absent(),
    this.exercisePhrase = const Value.absent(),
    this.matchedExerciseId = const Value.absent(),
    this.matchedExerciseName = const Value.absent(),
    this.loadValue = const Value.absent(),
    this.loadUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PersistedSessionSetsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int reps,
    required String exercisePhrase,
    this.matchedExerciseId = const Value.absent(),
    this.matchedExerciseName = const Value.absent(),
    this.loadValue = const Value.absent(),
    this.loadUnit = const Value.absent(),
    required DateTime createdAt,
  }) : sessionId = Value(sessionId),
       reps = Value(reps),
       exercisePhrase = Value(exercisePhrase),
       createdAt = Value(createdAt);
  static Insertable<PersistedSessionSet> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? reps,
    Expression<String>? exercisePhrase,
    Expression<int>? matchedExerciseId,
    Expression<String>? matchedExerciseName,
    Expression<double>? loadValue,
    Expression<String>? loadUnit,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (reps != null) 'reps': reps,
      if (exercisePhrase != null) 'exercise_phrase': exercisePhrase,
      if (matchedExerciseId != null) 'matched_exercise_id': matchedExerciseId,
      if (matchedExerciseName != null)
        'matched_exercise_name': matchedExerciseName,
      if (loadValue != null) 'load_value': loadValue,
      if (loadUnit != null) 'load_unit': loadUnit,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PersistedSessionSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? reps,
    Value<String>? exercisePhrase,
    Value<int?>? matchedExerciseId,
    Value<String?>? matchedExerciseName,
    Value<double?>? loadValue,
    Value<String?>? loadUnit,
    Value<DateTime>? createdAt,
  }) {
    return PersistedSessionSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      reps: reps ?? this.reps,
      exercisePhrase: exercisePhrase ?? this.exercisePhrase,
      matchedExerciseId: matchedExerciseId ?? this.matchedExerciseId,
      matchedExerciseName: matchedExerciseName ?? this.matchedExerciseName,
      loadValue: loadValue ?? this.loadValue,
      loadUnit: loadUnit ?? this.loadUnit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (exercisePhrase.present) {
      map['exercise_phrase'] = Variable<String>(exercisePhrase.value);
    }
    if (matchedExerciseId.present) {
      map['matched_exercise_id'] = Variable<int>(matchedExerciseId.value);
    }
    if (matchedExerciseName.present) {
      map['matched_exercise_name'] = Variable<String>(
        matchedExerciseName.value,
      );
    }
    if (loadValue.present) {
      map['load_value'] = Variable<double>(loadValue.value);
    }
    if (loadUnit.present) {
      map['load_unit'] = Variable<String>(loadUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersistedSessionSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('reps: $reps, ')
          ..write('exercisePhrase: $exercisePhrase, ')
          ..write('matchedExerciseId: $matchedExerciseId, ')
          ..write('matchedExerciseName: $matchedExerciseName, ')
          ..write('loadValue: $loadValue, ')
          ..write('loadUnit: $loadUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PersistedExerciseAliasesTable extends PersistedExerciseAliases
    with TableInfo<$PersistedExerciseAliasesTable, PersistedExerciseAliase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersistedExerciseAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persisted_exercises (id)',
    ),
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, exerciseId, alias];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persisted_exercise_aliases';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersistedExerciseAliase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exerciseId, alias},
  ];
  @override
  PersistedExerciseAliase map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersistedExerciseAliase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
    );
  }

  @override
  $PersistedExerciseAliasesTable createAlias(String alias) {
    return $PersistedExerciseAliasesTable(attachedDatabase, alias);
  }
}

class PersistedExerciseAliase extends DataClass
    implements Insertable<PersistedExerciseAliase> {
  final int id;
  final int exerciseId;
  final String alias;
  const PersistedExerciseAliase({
    required this.id,
    required this.exerciseId,
    required this.alias,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['alias'] = Variable<String>(alias);
    return map;
  }

  PersistedExerciseAliasesCompanion toCompanion(bool nullToAbsent) {
    return PersistedExerciseAliasesCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      alias: Value(alias),
    );
  }

  factory PersistedExerciseAliase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersistedExerciseAliase(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      alias: serializer.fromJson<String>(json['alias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'alias': serializer.toJson<String>(alias),
    };
  }

  PersistedExerciseAliase copyWith({int? id, int? exerciseId, String? alias}) =>
      PersistedExerciseAliase(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        alias: alias ?? this.alias,
      );
  PersistedExerciseAliase copyWithCompanion(
    PersistedExerciseAliasesCompanion data,
  ) {
    return PersistedExerciseAliase(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      alias: data.alias.present ? data.alias.value : this.alias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersistedExerciseAliase(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('alias: $alias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersistedExerciseAliase &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.alias == this.alias);
}

class PersistedExerciseAliasesCompanion
    extends UpdateCompanion<PersistedExerciseAliase> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<String> alias;
  const PersistedExerciseAliasesCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.alias = const Value.absent(),
  });
  PersistedExerciseAliasesCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required String alias,
  }) : exerciseId = Value(exerciseId),
       alias = Value(alias);
  static Insertable<PersistedExerciseAliase> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<String>? alias,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (alias != null) 'alias': alias,
    });
  }

  PersistedExerciseAliasesCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<String>? alias,
  }) {
    return PersistedExerciseAliasesCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      alias: alias ?? this.alias,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersistedExerciseAliasesCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('alias: $alias')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersistedSessionsTable persistedSessions =
      $PersistedSessionsTable(this);
  late final $PersistedExercisesTable persistedExercises =
      $PersistedExercisesTable(this);
  late final $PersistedSessionSetsTable persistedSessionSets =
      $PersistedSessionSetsTable(this);
  late final $PersistedExerciseAliasesTable persistedExerciseAliases =
      $PersistedExerciseAliasesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    persistedSessions,
    persistedExercises,
    persistedSessionSets,
    persistedExerciseAliases,
  ];
}

typedef $$PersistedSessionsTableCreateCompanionBuilder =
    PersistedSessionsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
    });
typedef $$PersistedSessionsTableUpdateCompanionBuilder =
    PersistedSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
    });

final class $$PersistedSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PersistedSessionsTable,
          PersistedSession
        > {
  $$PersistedSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $PersistedSessionSetsTable,
    List<PersistedSessionSet>
  >
  _persistedSessionSetsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.persistedSessionSets,
        aliasName: 'persisted_sessions__id__persisted_session_sets__session_id',
      );

  $$PersistedSessionSetsTableProcessedTableManager
  get persistedSessionSetsRefs {
    final manager = $$PersistedSessionSetsTableTableManager(
      $_db,
      $_db.persistedSessionSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _persistedSessionSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersistedSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PersistedSessionsTable> {
  $$PersistedSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> persistedSessionSetsRefs(
    Expression<bool> Function($$PersistedSessionSetsTableFilterComposer f) f,
  ) {
    final $$PersistedSessionSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.persistedSessionSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedSessionSetsTableFilterComposer(
            $db: $db,
            $table: $db.persistedSessionSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersistedSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersistedSessionsTable> {
  $$PersistedSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersistedSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersistedSessionsTable> {
  $$PersistedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  Expression<T> persistedSessionSetsRefs<T extends Object>(
    Expression<T> Function($$PersistedSessionSetsTableAnnotationComposer a) f,
  ) {
    final $$PersistedSessionSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.persistedSessionSets,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedSessionSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.persistedSessionSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PersistedSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersistedSessionsTable,
          PersistedSession,
          $$PersistedSessionsTableFilterComposer,
          $$PersistedSessionsTableOrderingComposer,
          $$PersistedSessionsTableAnnotationComposer,
          $$PersistedSessionsTableCreateCompanionBuilder,
          $$PersistedSessionsTableUpdateCompanionBuilder,
          (PersistedSession, $$PersistedSessionsTableReferences),
          PersistedSession,
          PrefetchHooks Function({bool persistedSessionSetsRefs})
        > {
  $$PersistedSessionsTableTableManager(
    _$AppDatabase db,
    $PersistedSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersistedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersistedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersistedSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
              }) => PersistedSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
              }) => PersistedSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersistedSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({persistedSessionSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (persistedSessionSetsRefs) db.persistedSessionSets,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (persistedSessionSetsRefs)
                    await $_getPrefetchedData<
                      PersistedSession,
                      $PersistedSessionsTable,
                      PersistedSessionSet
                    >(
                      currentTable: table,
                      referencedTable: $$PersistedSessionsTableReferences
                          ._persistedSessionSetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PersistedSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).persistedSessionSetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PersistedSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersistedSessionsTable,
      PersistedSession,
      $$PersistedSessionsTableFilterComposer,
      $$PersistedSessionsTableOrderingComposer,
      $$PersistedSessionsTableAnnotationComposer,
      $$PersistedSessionsTableCreateCompanionBuilder,
      $$PersistedSessionsTableUpdateCompanionBuilder,
      (PersistedSession, $$PersistedSessionsTableReferences),
      PersistedSession,
      PrefetchHooks Function({bool persistedSessionSetsRefs})
    >;
typedef $$PersistedExercisesTableCreateCompanionBuilder =
    PersistedExercisesCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      required String defaultUnit,
      Value<bool> isActive,
    });
typedef $$PersistedExercisesTableUpdateCompanionBuilder =
    PersistedExercisesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<String> defaultUnit,
      Value<bool> isActive,
    });

final class $$PersistedExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PersistedExercisesTable,
          PersistedExercise
        > {
  $$PersistedExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $PersistedSessionSetsTable,
    List<PersistedSessionSet>
  >
  _persistedSessionSetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persistedSessionSets,
    aliasName:
        'persisted_exercises__id__persisted_session_sets__matched_exercise_id',
  );

  $$PersistedSessionSetsTableProcessedTableManager
  get persistedSessionSetsRefs {
    final manager = $$PersistedSessionSetsTableTableManager(
      $_db,
      $_db.persistedSessionSets,
    ).filter((f) => f.matchedExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _persistedSessionSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PersistedExerciseAliasesTable,
    List<PersistedExerciseAliase>
  >
  _persistedExerciseAliasesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.persistedExerciseAliases,
        aliasName:
            'persisted_exercises__id__persisted_exercise_aliases__exercise_id',
      );

  $$PersistedExerciseAliasesTableProcessedTableManager
  get persistedExerciseAliasesRefs {
    final manager = $$PersistedExerciseAliasesTableTableManager(
      $_db,
      $_db.persistedExerciseAliases,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _persistedExerciseAliasesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersistedExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $PersistedExercisesTable> {
  $$PersistedExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> persistedSessionSetsRefs(
    Expression<bool> Function($$PersistedSessionSetsTableFilterComposer f) f,
  ) {
    final $$PersistedSessionSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.persistedSessionSets,
      getReferencedColumn: (t) => t.matchedExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedSessionSetsTableFilterComposer(
            $db: $db,
            $table: $db.persistedSessionSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> persistedExerciseAliasesRefs(
    Expression<bool> Function($$PersistedExerciseAliasesTableFilterComposer f)
    f,
  ) {
    final $$PersistedExerciseAliasesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.persistedExerciseAliases,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedExerciseAliasesTableFilterComposer(
                $db: $db,
                $table: $db.persistedExerciseAliases,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PersistedExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PersistedExercisesTable> {
  $$PersistedExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersistedExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersistedExercisesTable> {
  $$PersistedExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> persistedSessionSetsRefs<T extends Object>(
    Expression<T> Function($$PersistedSessionSetsTableAnnotationComposer a) f,
  ) {
    final $$PersistedSessionSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.persistedSessionSets,
          getReferencedColumn: (t) => t.matchedExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedSessionSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.persistedSessionSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> persistedExerciseAliasesRefs<T extends Object>(
    Expression<T> Function($$PersistedExerciseAliasesTableAnnotationComposer a)
    f,
  ) {
    final $$PersistedExerciseAliasesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.persistedExerciseAliases,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedExerciseAliasesTableAnnotationComposer(
                $db: $db,
                $table: $db.persistedExerciseAliases,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PersistedExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersistedExercisesTable,
          PersistedExercise,
          $$PersistedExercisesTableFilterComposer,
          $$PersistedExercisesTableOrderingComposer,
          $$PersistedExercisesTableAnnotationComposer,
          $$PersistedExercisesTableCreateCompanionBuilder,
          $$PersistedExercisesTableUpdateCompanionBuilder,
          (PersistedExercise, $$PersistedExercisesTableReferences),
          PersistedExercise,
          PrefetchHooks Function({
            bool persistedSessionSetsRefs,
            bool persistedExerciseAliasesRefs,
          })
        > {
  $$PersistedExercisesTableTableManager(
    _$AppDatabase db,
    $PersistedExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersistedExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersistedExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersistedExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> defaultUnit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => PersistedExercisesCompanion(
                id: id,
                name: name,
                category: category,
                defaultUnit: defaultUnit,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                required String defaultUnit,
                Value<bool> isActive = const Value.absent(),
              }) => PersistedExercisesCompanion.insert(
                id: id,
                name: name,
                category: category,
                defaultUnit: defaultUnit,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersistedExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                persistedSessionSetsRefs = false,
                persistedExerciseAliasesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (persistedSessionSetsRefs) db.persistedSessionSets,
                    if (persistedExerciseAliasesRefs)
                      db.persistedExerciseAliases,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (persistedSessionSetsRefs)
                        await $_getPrefetchedData<
                          PersistedExercise,
                          $PersistedExercisesTable,
                          PersistedSessionSet
                        >(
                          currentTable: table,
                          referencedTable: $$PersistedExercisesTableReferences
                              ._persistedSessionSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersistedExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).persistedSessionSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.matchedExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (persistedExerciseAliasesRefs)
                        await $_getPrefetchedData<
                          PersistedExercise,
                          $PersistedExercisesTable,
                          PersistedExerciseAliase
                        >(
                          currentTable: table,
                          referencedTable: $$PersistedExercisesTableReferences
                              ._persistedExerciseAliasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersistedExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).persistedExerciseAliasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PersistedExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersistedExercisesTable,
      PersistedExercise,
      $$PersistedExercisesTableFilterComposer,
      $$PersistedExercisesTableOrderingComposer,
      $$PersistedExercisesTableAnnotationComposer,
      $$PersistedExercisesTableCreateCompanionBuilder,
      $$PersistedExercisesTableUpdateCompanionBuilder,
      (PersistedExercise, $$PersistedExercisesTableReferences),
      PersistedExercise,
      PrefetchHooks Function({
        bool persistedSessionSetsRefs,
        bool persistedExerciseAliasesRefs,
      })
    >;
typedef $$PersistedSessionSetsTableCreateCompanionBuilder =
    PersistedSessionSetsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int reps,
      required String exercisePhrase,
      Value<int?> matchedExerciseId,
      Value<String?> matchedExerciseName,
      Value<double?> loadValue,
      Value<String?> loadUnit,
      required DateTime createdAt,
    });
typedef $$PersistedSessionSetsTableUpdateCompanionBuilder =
    PersistedSessionSetsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> reps,
      Value<String> exercisePhrase,
      Value<int?> matchedExerciseId,
      Value<String?> matchedExerciseName,
      Value<double?> loadValue,
      Value<String?> loadUnit,
      Value<DateTime> createdAt,
    });

final class $$PersistedSessionSetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PersistedSessionSetsTable,
          PersistedSessionSet
        > {
  $$PersistedSessionSetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersistedSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.persistedSessions.createAlias(
        'persisted_session_sets__session_id__persisted_sessions__id',
      );

  $$PersistedSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$PersistedSessionsTableTableManager(
      $_db,
      $_db.persistedSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersistedExercisesTable _matchedExerciseIdTable(_$AppDatabase db) =>
      db.persistedExercises.createAlias(
        'persisted_session_sets__matched_exercise_id__persisted_exercises__id',
      );

  $$PersistedExercisesTableProcessedTableManager? get matchedExerciseId {
    final $_column = $_itemColumn<int>('matched_exercise_id');
    if ($_column == null) return null;
    final manager = $$PersistedExercisesTableTableManager(
      $_db,
      $_db.persistedExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_matchedExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersistedSessionSetsTableFilterComposer
    extends Composer<_$AppDatabase, $PersistedSessionSetsTable> {
  $$PersistedSessionSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exercisePhrase => $composableBuilder(
    column: $table.exercisePhrase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchedExerciseName => $composableBuilder(
    column: $table.matchedExerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadValue => $composableBuilder(
    column: $table.loadValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loadUnit => $composableBuilder(
    column: $table.loadUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersistedSessionsTableFilterComposer get sessionId {
    final $$PersistedSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.persistedSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedSessionsTableFilterComposer(
            $db: $db,
            $table: $db.persistedSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersistedExercisesTableFilterComposer get matchedExerciseId {
    final $$PersistedExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchedExerciseId,
      referencedTable: $db.persistedExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedExercisesTableFilterComposer(
            $db: $db,
            $table: $db.persistedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersistedSessionSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersistedSessionSetsTable> {
  $$PersistedSessionSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercisePhrase => $composableBuilder(
    column: $table.exercisePhrase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchedExerciseName => $composableBuilder(
    column: $table.matchedExerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadValue => $composableBuilder(
    column: $table.loadValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadUnit => $composableBuilder(
    column: $table.loadUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersistedSessionsTableOrderingComposer get sessionId {
    final $$PersistedSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.persistedSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.persistedSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersistedExercisesTableOrderingComposer get matchedExerciseId {
    final $$PersistedExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchedExerciseId,
      referencedTable: $db.persistedExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.persistedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersistedSessionSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersistedSessionSetsTable> {
  $$PersistedSessionSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<String> get exercisePhrase => $composableBuilder(
    column: $table.exercisePhrase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get matchedExerciseName => $composableBuilder(
    column: $table.matchedExerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loadValue =>
      $composableBuilder(column: $table.loadValue, builder: (column) => column);

  GeneratedColumn<String> get loadUnit =>
      $composableBuilder(column: $table.loadUnit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PersistedSessionsTableAnnotationComposer get sessionId {
    final $$PersistedSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.persistedSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.persistedSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PersistedExercisesTableAnnotationComposer get matchedExerciseId {
    final $$PersistedExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.matchedExerciseId,
          referencedTable: $db.persistedExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.persistedExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PersistedSessionSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersistedSessionSetsTable,
          PersistedSessionSet,
          $$PersistedSessionSetsTableFilterComposer,
          $$PersistedSessionSetsTableOrderingComposer,
          $$PersistedSessionSetsTableAnnotationComposer,
          $$PersistedSessionSetsTableCreateCompanionBuilder,
          $$PersistedSessionSetsTableUpdateCompanionBuilder,
          (PersistedSessionSet, $$PersistedSessionSetsTableReferences),
          PersistedSessionSet,
          PrefetchHooks Function({bool sessionId, bool matchedExerciseId})
        > {
  $$PersistedSessionSetsTableTableManager(
    _$AppDatabase db,
    $PersistedSessionSetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersistedSessionSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersistedSessionSetsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PersistedSessionSetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<String> exercisePhrase = const Value.absent(),
                Value<int?> matchedExerciseId = const Value.absent(),
                Value<String?> matchedExerciseName = const Value.absent(),
                Value<double?> loadValue = const Value.absent(),
                Value<String?> loadUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PersistedSessionSetsCompanion(
                id: id,
                sessionId: sessionId,
                reps: reps,
                exercisePhrase: exercisePhrase,
                matchedExerciseId: matchedExerciseId,
                matchedExerciseName: matchedExerciseName,
                loadValue: loadValue,
                loadUnit: loadUnit,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int reps,
                required String exercisePhrase,
                Value<int?> matchedExerciseId = const Value.absent(),
                Value<String?> matchedExerciseName = const Value.absent(),
                Value<double?> loadValue = const Value.absent(),
                Value<String?> loadUnit = const Value.absent(),
                required DateTime createdAt,
              }) => PersistedSessionSetsCompanion.insert(
                id: id,
                sessionId: sessionId,
                reps: reps,
                exercisePhrase: exercisePhrase,
                matchedExerciseId: matchedExerciseId,
                matchedExerciseName: matchedExerciseName,
                loadValue: loadValue,
                loadUnit: loadUnit,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersistedSessionSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, matchedExerciseId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$PersistedSessionSetsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$PersistedSessionSetsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (matchedExerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.matchedExerciseId,
                                    referencedTable:
                                        $$PersistedSessionSetsTableReferences
                                            ._matchedExerciseIdTable(db),
                                    referencedColumn:
                                        $$PersistedSessionSetsTableReferences
                                            ._matchedExerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PersistedSessionSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersistedSessionSetsTable,
      PersistedSessionSet,
      $$PersistedSessionSetsTableFilterComposer,
      $$PersistedSessionSetsTableOrderingComposer,
      $$PersistedSessionSetsTableAnnotationComposer,
      $$PersistedSessionSetsTableCreateCompanionBuilder,
      $$PersistedSessionSetsTableUpdateCompanionBuilder,
      (PersistedSessionSet, $$PersistedSessionSetsTableReferences),
      PersistedSessionSet,
      PrefetchHooks Function({bool sessionId, bool matchedExerciseId})
    >;
typedef $$PersistedExerciseAliasesTableCreateCompanionBuilder =
    PersistedExerciseAliasesCompanion Function({
      Value<int> id,
      required int exerciseId,
      required String alias,
    });
typedef $$PersistedExerciseAliasesTableUpdateCompanionBuilder =
    PersistedExerciseAliasesCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<String> alias,
    });

final class $$PersistedExerciseAliasesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PersistedExerciseAliasesTable,
          PersistedExerciseAliase
        > {
  $$PersistedExerciseAliasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersistedExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.persistedExercises.createAlias(
        'persisted_exercise_aliases__exercise_id__persisted_exercises__id',
      );

  $$PersistedExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$PersistedExercisesTableTableManager(
      $_db,
      $_db.persistedExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersistedExerciseAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $PersistedExerciseAliasesTable> {
  $$PersistedExerciseAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  $$PersistedExercisesTableFilterComposer get exerciseId {
    final $$PersistedExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.persistedExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedExercisesTableFilterComposer(
            $db: $db,
            $table: $db.persistedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersistedExerciseAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PersistedExerciseAliasesTable> {
  $$PersistedExerciseAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersistedExercisesTableOrderingComposer get exerciseId {
    final $$PersistedExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.persistedExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersistedExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.persistedExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersistedExerciseAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersistedExerciseAliasesTable> {
  $$PersistedExerciseAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  $$PersistedExercisesTableAnnotationComposer get exerciseId {
    final $$PersistedExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseId,
          referencedTable: $db.persistedExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersistedExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.persistedExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PersistedExerciseAliasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersistedExerciseAliasesTable,
          PersistedExerciseAliase,
          $$PersistedExerciseAliasesTableFilterComposer,
          $$PersistedExerciseAliasesTableOrderingComposer,
          $$PersistedExerciseAliasesTableAnnotationComposer,
          $$PersistedExerciseAliasesTableCreateCompanionBuilder,
          $$PersistedExerciseAliasesTableUpdateCompanionBuilder,
          (PersistedExerciseAliase, $$PersistedExerciseAliasesTableReferences),
          PersistedExerciseAliase,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$PersistedExerciseAliasesTableTableManager(
    _$AppDatabase db,
    $PersistedExerciseAliasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersistedExerciseAliasesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PersistedExerciseAliasesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PersistedExerciseAliasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<String> alias = const Value.absent(),
              }) => PersistedExerciseAliasesCompanion(
                id: id,
                exerciseId: exerciseId,
                alias: alias,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required String alias,
              }) => PersistedExerciseAliasesCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                alias: alias,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersistedExerciseAliasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$PersistedExerciseAliasesTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$PersistedExerciseAliasesTableReferences
                                        ._exerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PersistedExerciseAliasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersistedExerciseAliasesTable,
      PersistedExerciseAliase,
      $$PersistedExerciseAliasesTableFilterComposer,
      $$PersistedExerciseAliasesTableOrderingComposer,
      $$PersistedExerciseAliasesTableAnnotationComposer,
      $$PersistedExerciseAliasesTableCreateCompanionBuilder,
      $$PersistedExerciseAliasesTableUpdateCompanionBuilder,
      (PersistedExerciseAliase, $$PersistedExerciseAliasesTableReferences),
      PersistedExerciseAliase,
      PrefetchHooks Function({bool exerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersistedSessionsTableTableManager get persistedSessions =>
      $$PersistedSessionsTableTableManager(_db, _db.persistedSessions);
  $$PersistedExercisesTableTableManager get persistedExercises =>
      $$PersistedExercisesTableTableManager(_db, _db.persistedExercises);
  $$PersistedSessionSetsTableTableManager get persistedSessionSets =>
      $$PersistedSessionSetsTableTableManager(_db, _db.persistedSessionSets);
  $$PersistedExerciseAliasesTableTableManager get persistedExerciseAliases =>
      $$PersistedExerciseAliasesTableTableManager(
        _db,
        _db.persistedExerciseAliases,
      );
}
