class CsvExerciseParser {
  const CsvExerciseParser();

  ParsedExerciseCsv parse(String csvText) {
    final sanitizedCsvText = csvText.replaceFirst(_utf8Bom, '');
    final lines = sanitizedCsvText
        .split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      throw const ExerciseCsvFormatException('CSV input is empty.');
    }

    final headers = _parseRow(
      lines.first,
    ).map((header) => _normalizeHeader(header)).toList();
    final nameIndex = headers.indexOf('name');
    final categoryIndex = headers.indexOf('category');
    final defaultUnitIndex = headers.indexOf('default_unit');
    final aliasIndexes = <int>[];

    for (var index = 0; index < headers.length; index++) {
      if (headers[index].startsWith('alias_')) {
        aliasIndexes.add(index);
      }
    }

    if (nameIndex == -1 || categoryIndex == -1 || defaultUnitIndex == -1) {
      throw const ExerciseCsvFormatException(
        'CSV must include name, category, and default_unit headers.',
      );
    }

    final rows = <ParsedExerciseCsvRow>[];
    var skippedRows = 0;

    for (final line in lines.skip(1)) {
      final columns = _parseRow(line);
      final name = _valueAt(columns, nameIndex).trim();
      if (name.isEmpty) {
        skippedRows++;
        continue;
      }

      rows.add(
        ParsedExerciseCsvRow(
          name: name,
          category: _valueAt(columns, categoryIndex).trim(),
          defaultUnit: _valueAt(columns, defaultUnitIndex).trim(),
          aliases: aliasIndexes
              .map((index) => _valueAt(columns, index).trim())
              .where((alias) => alias.isNotEmpty)
              .toList(),
        ),
      );
    }

    return ParsedExerciseCsv(rows: rows, skippedRows: skippedRows);
  }

  List<String> _parseRow(String row) {
    final values = <String>[];
    final buffer = StringBuffer();
    var insideQuotes = false;

    for (var index = 0; index < row.length; index++) {
      final char = row[index];
      if (char == '"') {
        final nextIsQuote = index + 1 < row.length && row[index + 1] == '"';
        if (insideQuotes && nextIsQuote) {
          buffer.write('"');
          index++;
          continue;
        }

        insideQuotes = !insideQuotes;
        continue;
      }

      if (char == ',' && !insideQuotes) {
        values.add(buffer.toString());
        buffer.clear();
        continue;
      }

      buffer.write(char);
    }

    values.add(buffer.toString());
    return values;
  }

  String _valueAt(List<String> columns, int index) {
    if (index < 0 || index >= columns.length) {
      return '';
    }

    return columns[index];
  }

  String _normalizeHeader(String header) {
    return header.replaceFirst(_utf8Bom, '').trim().toLowerCase();
  }

  static const _utf8Bom = '\uFEFF';
}

class ParsedExerciseCsv {
  const ParsedExerciseCsv({required this.rows, required this.skippedRows});

  final List<ParsedExerciseCsvRow> rows;
  final int skippedRows;
}

class ParsedExerciseCsvRow {
  const ParsedExerciseCsvRow({
    required this.name,
    required this.category,
    required this.defaultUnit,
    required this.aliases,
  });

  final String name;
  final String category;
  final String defaultUnit;
  final List<String> aliases;
}

class ExerciseCsvFormatException implements Exception {
  const ExerciseCsvFormatException(this.message);

  final String message;
}
