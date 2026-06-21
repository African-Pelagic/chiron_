import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../core/database/app_database.dart';
import '../features/exercise_library/application/exercise_library_controller.dart';
import '../features/exercise_library/data/csv_file_access.dart';
import '../features/exercise_library/data/drift_exercise_library_repository.dart';
import '../features/exercise_library/data/exercise_library_repository.dart';
import '../features/session/application/session_flow_controller.dart';
import '../features/session/data/drift_session_repository.dart';
import '../features/session/data/session_repository.dart';
import '../features/speech/application/voice_capture_controller.dart';
import '../features/speech/data/record_voice_capture_service.dart';
import '../features/speech/data/voice_capture_service.dart';
import '../features/speech/data/voice_transcription_service.dart';
import '../features/speech/data/whisper_voice_transcription_service.dart';
import 'router.dart';
import 'theme.dart';

class WorkoutApp extends StatefulWidget {
  const WorkoutApp({
    super.key,
    this.now,
    this.sessionRepository,
    this.exerciseLibraryRepository,
    this.csvFileAccess,
    this.voiceCaptureService,
    this.voiceTranscriptionService,
    this.voiceClipPathBuilder,
  });

  final DateTime Function()? now;
  final SessionRepository? sessionRepository;
  final ExerciseLibraryRepository? exerciseLibraryRepository;
  final CsvFileAccess? csvFileAccess;
  final VoiceCaptureService? voiceCaptureService;
  final VoiceTranscriptionService? voiceTranscriptionService;
  final VoiceClipPathBuilder? voiceClipPathBuilder;

  @override
  State<WorkoutApp> createState() => _WorkoutAppState();
}

class _WorkoutAppState extends State<WorkoutApp> {
  AppDatabase? _database;
  late final ExerciseLibraryController _exerciseLibraryController;
  late final SessionFlowController _sessionFlowController;
  late final VoiceCaptureController _voiceCaptureController;
  late final CsvFileAccess _csvFileAccess;

  @override
  void initState() {
    super.initState();
    final sessionRepository =
        widget.sessionRepository ?? _buildSessionRepository();
    final exerciseLibraryRepository =
        widget.exerciseLibraryRepository ?? _buildExerciseLibraryRepository();
    final voiceCaptureService =
        widget.voiceCaptureService ?? RecordVoiceCaptureService();
    _csvFileAccess = widget.csvFileAccess ?? const DeviceCsvFileAccess();
    final voiceTranscriptionService =
        widget.voiceTranscriptionService ?? WhisperVoiceTranscriptionService();
    _sessionFlowController = SessionFlowController(
      sessionRepository: sessionRepository,
      now: widget.now,
    );
    _exerciseLibraryController = ExerciseLibraryController(
      exerciseLibraryRepository: exerciseLibraryRepository,
    );
    _voiceCaptureController = VoiceCaptureController(
      voiceCaptureService: voiceCaptureService,
      voiceTranscriptionService: voiceTranscriptionService,
      now: widget.now,
      clipPathBuilder: widget.voiceClipPathBuilder,
    );
    unawaited(_sessionFlowController.hydrate());
    unawaited(_exerciseLibraryController.hydrate());
  }

  @override
  void dispose() {
    _voiceCaptureController.dispose();
    _exerciseLibraryController.dispose();
    _sessionFlowController.dispose();
    final database = _database;
    if (database != null) {
      unawaited(database.close());
    }
    super.dispose();
  }

  SessionRepository _buildSessionRepository() {
    return DriftSessionRepository(_databaseInstance);
  }

  ExerciseLibraryRepository _buildExerciseLibraryRepository() {
    return DriftExerciseLibraryRepository(_databaseInstance);
  }

  AppDatabase get _databaseInstance {
    return _database ??= AppDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chiron',
      debugShowCheckedModeBanner: false,
      theme: buildMaterialTheme(),
      darkTheme: buildMaterialTheme(),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return ShadTheme(data: buildShadTheme(), child: child!);
      },
      onGenerateRoute: AppRouter(
        sessionFlowController: _sessionFlowController,
        exerciseLibraryController: _exerciseLibraryController,
        voiceCaptureController: _voiceCaptureController,
        csvFileAccess: _csvFileAccess,
      ).onGenerateRoute,
      initialRoute: AppRoutePath.session,
    );
  }
}
