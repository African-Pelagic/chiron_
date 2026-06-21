import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

abstract class CsvFileAccess {
  Future<String?> pickCsvText();

  Future<String?> saveSchemaCsv(String csvText);

  Future<String?> saveSetExportCsv(String csvText);
}

class DeviceCsvFileAccess implements CsvFileAccess {
  const DeviceCsvFileAccess();

  @override
  Future<String?> pickCsvText() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>['csv'],
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) {
      return null;
    }

    final bytes = file.bytes;
    if (bytes != null) {
      return utf8.decode(bytes);
    }

    final path = file.path;
    if (path == null) {
      return null;
    }

    if (kIsWeb) {
      return null;
    }

    return File(path).readAsString();
  }

  @override
  Future<String?> saveSchemaCsv(String csvText) {
    return FilePicker.saveFile(
      dialogTitle: 'Save CSV schema',
      fileName: 'chiron_exercise_schema.csv',
      type: FileType.custom,
      allowedExtensions: const <String>['csv'],
      bytes: Uint8List.fromList(utf8.encode(csvText)),
    );
  }

  @override
  Future<String?> saveSetExportCsv(String csvText) {
    return FilePicker.saveFile(
      dialogTitle: 'Save set export CSV',
      fileName: 'chiron_sets_export.csv',
      type: FileType.custom,
      allowedExtensions: const <String>['csv'],
      bytes: Uint8List.fromList(utf8.encode(csvText)),
    );
  }
}
