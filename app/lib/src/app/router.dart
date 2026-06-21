import 'package:flutter/material.dart';

import '../features/exercise_library/application/exercise_library_controller.dart';
import '../features/exercise_library/data/csv_file_access.dart';
import '../features/exercise_library/domain/exercise_definition.dart';
import '../features/exercise_library/presentation/exercise_editor_screen.dart';
import '../features/exercise_library/presentation/exercise_library_screen.dart';
import '../features/exercise_library/presentation/import_csv_screen.dart';
import '../features/session/application/session_flow_controller.dart';
import '../features/session/presentation/performance_screen.dart';
import '../features/session/presentation/session_screen.dart';
import '../features/session/presentation/session_detail_screen.dart';
import '../features/speech/application/voice_capture_controller.dart';

abstract final class AppRoutePath {
  static const session = '/';
  static const sessionDetail = '/session-detail';
  static const performance = '/performance';
  static const exerciseLibrary = '/exercise-library';
  static const exerciseEditor = '/exercise-editor';
  static const importCsv = '/import-csv';
}

class SessionDetailRouteArguments {
  const SessionDetailRouteArguments({required this.sessionId});

  final int sessionId;
}

class ExerciseEditorRouteArguments {
  const ExerciseEditorRouteArguments({this.exercise});

  final ExerciseDefinition? exercise;
}

final class AppRouter {
  const AppRouter({
    required this.sessionFlowController,
    required this.exerciseLibraryController,
    required this.voiceCaptureController,
    required this.csvFileAccess,
  });

  final SessionFlowController sessionFlowController;
  final ExerciseLibraryController exerciseLibraryController;
  final VoiceCaptureController voiceCaptureController;
  final CsvFileAccess csvFileAccess;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutePath.session:
        return MaterialPageRoute<void>(
          builder: (_) => SessionScreen(
            sessionFlowController: sessionFlowController,
            voiceCaptureController: voiceCaptureController,
            csvFileAccess: csvFileAccess,
          ),
          settings: settings,
        );
      case AppRoutePath.sessionDetail:
        final args =
            settings.arguments as SessionDetailRouteArguments? ??
            SessionDetailRouteArguments(
              sessionId: sessionFlowController.lastCompletedSession?.id ?? 0,
            );
        return MaterialPageRoute<void>(
          builder: (_) => SessionDetailScreen(
            sessionFlowController: sessionFlowController,
            sessionId: args.sessionId,
          ),
          settings: settings,
        );
      case AppRoutePath.performance:
        return MaterialPageRoute<void>(
          builder: (_) => PerformanceScreen(
            sessionFlowController: sessionFlowController,
            exerciseLibraryController: exerciseLibraryController,
          ),
          settings: settings,
        );
      case AppRoutePath.exerciseLibrary:
        return MaterialPageRoute<void>(
          builder: (_) => ExerciseLibraryScreen(
            exerciseLibraryController: exerciseLibraryController,
          ),
          settings: settings,
        );
      case AppRoutePath.exerciseEditor:
        final args = settings.arguments as ExerciseEditorRouteArguments?;
        return MaterialPageRoute<void>(
          builder: (_) => ExerciseEditorScreen(
            exerciseLibraryController: exerciseLibraryController,
            exercise: args?.exercise,
          ),
          settings: settings,
        );
      case AppRoutePath.importCsv:
        return MaterialPageRoute<void>(
          builder: (_) => ImportCsvScreen(
            exerciseLibraryController: exerciseLibraryController,
            csvFileAccess: csvFileAccess,
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => SessionScreen(
            sessionFlowController: sessionFlowController,
            voiceCaptureController: voiceCaptureController,
            csvFileAccess: csvFileAccess,
          ),
          settings: settings,
        );
    }
  }
}
