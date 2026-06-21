import 'package:record/record.dart';

import 'voice_capture_service.dart';

class RecordVoiceCaptureService implements VoiceCaptureService {
  RecordVoiceCaptureService({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;

  @override
  Future<void> cancel() {
    return _recorder.cancel();
  }

  @override
  Future<void> dispose() {
    return _recorder.dispose();
  }

  @override
  Future<bool> hasPermission() {
    return _recorder.hasPermission();
  }

  @override
  Future<void> start({required String path}) {
    return _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        numChannels: 1,
        sampleRate: 16000,
      ),
      path: path,
    );
  }

  @override
  Future<String?> stop() {
    return _recorder.stop();
  }
}
