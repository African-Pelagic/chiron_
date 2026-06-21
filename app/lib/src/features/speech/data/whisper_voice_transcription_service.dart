import 'dart:io';
import 'dart:math';

import 'package:whisper_ggml_plus/whisper_ggml_plus.dart' as whisper;

import 'voice_transcription_service.dart';

class WhisperVoiceTranscriptionService implements VoiceTranscriptionService {
  WhisperVoiceTranscriptionService({
    whisper.WhisperController? whisperController,
    this._model = whisper.WhisperModel.tinyEn,
    this._language = 'en',
  }) : _whisperController = whisperController ?? whisper.WhisperController();

  final whisper.WhisperController _whisperController;
  final whisper.WhisperModel _model;
  final String _language;

  @override
  Future<String> transcribe({required String audioPath}) async {
    final modelPath = await _whisperController.getPath(_model);
    final modelFile = File(modelPath);
    if (!modelFile.existsSync()) {
      await _whisperController.downloadModel(_model);
    }

    final result = await _whisperController.transcribe(
      model: _model,
      audioPath: audioPath,
      lang: _language,
      withTimestamps: false,
      convert: false,
      threads: _threadCount,
    );

    final transcript = _normalizeTranscript(result?.transcription.text);
    if (transcript == null || transcript.isEmpty) {
      throw Exception('Whisper did not return any text.');
    }

    return transcript;
  }

  int get _threadCount => max(1, min(4, Platform.numberOfProcessors - 1));

  String? _normalizeTranscript(String? value) {
    if (value == null) {
      return null;
    }

    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
