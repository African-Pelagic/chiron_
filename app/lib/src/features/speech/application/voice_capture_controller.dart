import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../data/voice_capture_service.dart';
import '../data/voice_transcription_service.dart';
import '../domain/voice_capture_clip.dart';

enum VoiceCaptureStatus { idle, recording, recorded }

typedef VoiceClipPathBuilder = Future<String> Function(DateTime capturedAt);

class VoiceCaptureController extends ChangeNotifier {
  VoiceCaptureController({
    required this.voiceCaptureService,
    required this.voiceTranscriptionService,
    DateTime Function()? now,
    VoiceClipPathBuilder? clipPathBuilder,
  }) : _now = now ?? DateTime.now,
       _clipPathBuilder = clipPathBuilder ?? _defaultClipPathBuilder;

  final VoiceCaptureService voiceCaptureService;
  final VoiceTranscriptionService voiceTranscriptionService;
  final DateTime Function() _now;
  final VoiceClipPathBuilder _clipPathBuilder;

  VoiceCaptureStatus _status = VoiceCaptureStatus.idle;
  VoiceCaptureClip? _lastClip;
  String? _errorMessage;
  bool _isBusy = false;
  bool _isTranscribing = false;
  DateTime? _recordingStartedAt;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  String? _lastTranscript;

  VoiceCaptureStatus get status => _status;
  VoiceCaptureClip? get lastClip => _lastClip;
  String? get errorMessage => _errorMessage;
  bool get isBusy => _isBusy;
  bool get isRecording => _status == VoiceCaptureStatus.recording;
  bool get isTranscribing => _isTranscribing;
  Duration get elapsed => _elapsed;
  String? get lastTranscript => _lastTranscript;

  Future<void> startRecording() async {
    if (_isBusy || isRecording) {
      return;
    }

    _isBusy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!await voiceCaptureService.hasPermission()) {
        _errorMessage = 'Microphone permission is required for voice capture.';
        return;
      }

      final startedAt = _now();
      final path = await _clipPathBuilder(startedAt);
      await voiceCaptureService.start(path: path);

      _status = VoiceCaptureStatus.recording;
      _lastTranscript = null;
      _recordingStartedAt = startedAt;
      _elapsed = Duration.zero;
      _startTicker();
    } catch (_) {
      _errorMessage = 'Voice capture could not start right now.';
      _status = VoiceCaptureStatus.idle;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> stopRecording() async {
    if (_isBusy || !isRecording) {
      return;
    }

    _isBusy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final path = await voiceCaptureService.stop();
      final startedAt = _recordingStartedAt;
      _stopTicker();
      _recordingStartedAt = null;

      if (path == null || startedAt == null) {
        _status = VoiceCaptureStatus.idle;
        _errorMessage = 'Voice capture did not produce an audio clip.';
        return;
      }

      _lastClip = VoiceCaptureClip(
        path: path,
        duration: _elapsed,
        capturedAt: _now(),
      );
      _lastTranscript = null;
      _status = VoiceCaptureStatus.recorded;
      _elapsed = Duration.zero;
    } catch (_) {
      _stopTicker();
      _recordingStartedAt = null;
      _status = VoiceCaptureStatus.idle;
      _errorMessage = 'Voice capture could not stop cleanly.';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> discardLastClip() async {
    if (_isBusy) {
      return;
    }

    _lastClip = null;
    _lastTranscript = null;
    if (!isRecording) {
      _status = VoiceCaptureStatus.idle;
    }
    notifyListeners();
  }

  Future<String?> transcribeLastClip() async {
    if (_isBusy || isRecording) {
      return null;
    }

    final clip = _lastClip;
    if (clip == null) {
      _errorMessage = 'Record a voice clip before transcribing it.';
      notifyListeners();
      return null;
    }

    _isBusy = true;
    _isTranscribing = true;
    _errorMessage = null;
    _lastTranscript = null;
    notifyListeners();

    try {
      final transcript = await voiceTranscriptionService.transcribe(
        audioPath: clip.path,
      );
      _lastTranscript = transcript;
      return transcript;
    } catch (_) {
      _errorMessage =
          'Voice transcription could not complete right now. '
          'On first use, check network so the local model can download.';
      return null;
    } finally {
      _isTranscribing = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<String?> stopRecordingAndTranscribe() async {
    if (_isBusy || !isRecording) {
      return null;
    }

    await stopRecording();
    if (_lastClip == null || _errorMessage != null) {
      return null;
    }

    return transcribeLastClip();
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTicker();
    unawaited(voiceCaptureService.dispose());
    super.dispose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      final startedAt = _recordingStartedAt;
      if (startedAt == null) {
        return;
      }

      _elapsed = _now().difference(startedAt);
      notifyListeners();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  static Future<String> _defaultClipPathBuilder(DateTime capturedAt) async {
    final tempDirectory = await getTemporaryDirectory();
    final timestamp = capturedAt.millisecondsSinceEpoch;
    return '${tempDirectory.path}/voice-capture-$timestamp.wav';
  }
}
