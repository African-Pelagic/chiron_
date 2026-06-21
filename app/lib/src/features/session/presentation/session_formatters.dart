import '../domain/captured_set.dart';
import '../domain/grouped_session_set.dart';

String formatSessionTime(DateTime dateTime) {
  return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
}

String formatSessionDate(DateTime dateTime) {
  return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
}

String formatSessionDateTime(DateTime dateTime) {
  return '${formatSessionDate(dateTime)} ${formatSessionTime(dateTime)}';
}

String formatSessionDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }

  if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m';
  }

  return '${duration.inSeconds}s';
}

String formatCapturedSet(CapturedSet capturedSet) {
  final buffer = StringBuffer(
    '${capturedSet.reps} ${capturedSet.displayExerciseName}',
  );
  if (capturedSet.hasLoad) {
    buffer.write(
      ' at ${formatLoadValue(capturedSet.loadValue!)} ${capturedSet.loadUnit}',
    );
  }

  return buffer.toString();
}

String formatGroupedSessionSet(GroupedSessionSet groupedSessionSet) {
  final setLabel = groupedSessionSet.count == 1 ? 'set' : 'sets';
  return '${groupedSessionSet.count} $setLabel of '
      '${groupedSessionSet.reps} ${groupedSessionSet.exerciseName} at '
      '${formatLoadValue(groupedSessionSet.loadValue)} ${groupedSessionSet.loadUnit}';
}

String formatLoadValue(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(1);
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
