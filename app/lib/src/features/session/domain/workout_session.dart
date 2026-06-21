class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
  });

  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;

  bool get isActive => endedAt == null;

  Duration get duration {
    final finishedAt = endedAt ?? DateTime.now();
    return finishedAt.difference(startedAt);
  }

  WorkoutSession end(DateTime endedAt) {
    return WorkoutSession(id: id, startedAt: startedAt, endedAt: endedAt);
  }
}
