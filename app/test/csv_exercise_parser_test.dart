import 'package:flutter_test/flutter_test.dart';

import 'package:chiron/src/features/exercise_library/data/csv_exercise_parser.dart';

void main() {
  const parser = CsvExerciseParser();

  test('parses CSV files with a UTF-8 BOM in the header row', () {
    final parsed = parser.parse(
      '\uFEFFname,alias_1,category,default_unit\n'
      'Dips,weighted dips,push,kg\n',
    );

    expect(parsed.skippedRows, 0);
    expect(parsed.rows, hasLength(1));
    expect(parsed.rows.first.name, 'Dips');
    expect(parsed.rows.first.aliases, <String>['weighted dips']);
    expect(parsed.rows.first.category, 'push');
    expect(parsed.rows.first.defaultUnit, 'kg');
  });
}
