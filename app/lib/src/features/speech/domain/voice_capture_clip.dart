class VoiceCaptureClip {
  const VoiceCaptureClip({
    required this.path,
    required this.duration,
    required this.capturedAt,
  });

  final String path;
  final Duration duration;
  final DateTime capturedAt;
}
