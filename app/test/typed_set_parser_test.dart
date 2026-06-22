import 'package:chiron/src/features/session/data/typed_set_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = TypedSetParser();

  test('parses reps, exercise phrase, and normalized load unit', () {
    final parsed = parser.parse('12 dips 30 kilos');

    expect(parsed.reps, 12);
    expect(parsed.exercisePhrase, 'dips');
    expect(parsed.loadValue, 30);
    expect(parsed.loadUnit, 'kg');
  });

  test('parses a set when load is present', () {
    final parsed = parser.parse('8 pull up 20 kg');

    expect(parsed.reps, 8);
    expect(parsed.exercisePhrase, 'pull up');
    expect(parsed.loadValue, 20);
    expect(parsed.loadUnit, 'kg');
  });

  test('ignores Whisper-style punctuation around tokens', () {
    final parsed = parser.parse('12 weighted dips, 30 kilos.');

    expect(parsed.reps, 12);
    expect(parsed.exercisePhrase, 'weighted dips');
    expect(parsed.loadValue, 30);
    expect(parsed.loadUnit, 'kg');
  });

  test('rejects phrases without a leading rep count', () {
    expect(
      () => parser.parse('dips 30 kilos'),
      throwsA(isA<TypedSetFormatException>()),
    );
  });

  test('rejects phrases without an exercise phrase', () {
    expect(
      () => parser.parse('12'),
      throwsA(isA<TypedSetFormatException>()),
    );
  });

  test('rejects phrases without a trailing load and unit', () {
    expect(
      () => parser.parse('8 pull up'),
      throwsA(isA<TypedSetFormatException>()),
    );
  });
}
