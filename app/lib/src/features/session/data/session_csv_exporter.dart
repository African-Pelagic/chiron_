import '../domain/captured_set.dart';
import '../domain/workout_session.dart';

class SessionCsvExporter {
  const SessionCsvExporter();

  String export(List<SessionCsvExportRecord> records) {
    final buffer = StringBuffer(
      'session_id,session_started_at,session_ended_at,set_id,set_captured_at,canonical_exercise_name,captured_exercise_phrase,reps,load_value,load_unit\n',
    );

    for (final record in records) {
      final session = record.session;
      for (final capturedSet in record.sets) {
        buffer.writeln(
          <String>[
            '${session.id}',
            session.startedAt.toIso8601String(),
            session.endedAt?.toIso8601String() ?? '',
            '${capturedSet.id}',
            capturedSet.createdAt.toIso8601String(),
            capturedSet.matchedExerciseName ?? '',
            capturedSet.exercisePhrase,
            '${capturedSet.reps}',
            capturedSet.loadValue?.toString() ?? '',
            capturedSet.loadUnit ?? '',
          ].map(_escapeField).join(','),
        );
      }
    }

    return buffer.toString();
  }

  String _escapeField(String value) {
    if (!value.contains(',') &&
        !value.contains('"') &&
        !value.contains('\n') &&
        !value.contains('\r')) {
      return value;
    }

    return '"${value.replaceAll('"', '""')}"';
  }
}

class SessionCsvExportRecord {
  const SessionCsvExportRecord({required this.session, required this.sets});

  final WorkoutSession session;
  final List<CapturedSet> sets;
}
