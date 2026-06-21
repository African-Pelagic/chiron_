abstract class VoiceCaptureService {
  Future<bool> hasPermission();

  Future<void> start({required String path});

  Future<String?> stop();

  Future<void> cancel();

  Future<void> dispose();
}
