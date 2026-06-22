import 'package:flutter_test/flutter_test.dart';

import 'package:chiron/src/features/session/data/session_csv_exporter.dart';
import 'package:chiron/src/features/session/domain/captured_set.dart';
import 'package:chiron/src/features/session/domain/workout_session.dart';

void main() {
  const exporter = SessionCsvExporter();

  test('exports one row per captured set across sessions', () {
    final csv = exporter.export(<SessionCsvExportRecord>[
      SessionCsvExportRecord(
        session: WorkoutSession(
          id: 1,
          startedAt: DateTime.utc(2026, 6, 21, 9, 0),
          endedAt: DateTime.utc(2026, 6, 21, 9, 45),
        ),
        sets: <CapturedSet>[
          CapturedSet(
            id: 10,
            sessionId: 1,
            reps: 12,
            exercisePhrase: 'weighted dips',
            matchedExerciseId: 1,
            matchedExerciseName: 'Dips',
            loadValue: 30,
            loadUnit: 'kg',
            createdAt: DateTime.utc(2026, 6, 21, 9, 5),
          ),
          CapturedSet(
            id: 11,
            sessionId: 1,
            reps: 8,
            exercisePhrase: 'pullup',
            matchedExerciseId: 2,
            matchedExerciseName: 'Pull Up',
            loadValue: 20,
            loadUnit: 'kg',
            createdAt: DateTime.utc(2026, 6, 21, 9, 10),
          ),
        ],
      ),
    ]);

    expect(
      csv,
      startsWith(
        'session_id,session_started_at,session_ended_at,set_id,set_captured_at,canonical_exercise_name,captured_exercise_phrase,reps,load_value,load_unit\n',
      ),
    );
    expect(csv, contains('1,2026-06-21T09:00:00.000Z,2026-06-21T09:45:00.000Z,10,2026-06-21T09:05:00.000Z,Dips,weighted dips,12,30.0,kg'));
    expect(csv, contains('1,2026-06-21T09:00:00.000Z,2026-06-21T09:45:00.000Z,11,2026-06-21T09:10:00.000Z,Pull Up,pullup,8,20.0,kg'));
  });

  test('escapes quoted or comma-containing fields', () {
    final csv = exporter.export(<SessionCsvExportRecord>[
      SessionCsvExportRecord(
        session: WorkoutSession(
          id: 2,
          startedAt: DateTime.utc(2026, 6, 21, 10, 0),
        ),
        sets: <CapturedSet>[
          CapturedSet(
            id: 20,
            sessionId: 2,
            reps: 5,
            exercisePhrase: 'press, strict',
            matchedExerciseId: 3,
            matchedExerciseName: 'Press "Strict"',
            loadValue: 40,
            loadUnit: 'kg',
            createdAt: DateTime.utc(2026, 6, 21, 10, 5),
          ),
        ],
      ),
    ]);

    expect(csv, contains('"Press ""Strict"""'));
    expect(csv, contains('"press, strict"'));
  });
}
