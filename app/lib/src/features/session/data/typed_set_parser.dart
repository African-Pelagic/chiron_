import '../domain/captured_set_draft.dart';

class TypedSetParser {
  const TypedSetParser();

  static const Map<String, String> _unitAliases = <String, String>{
    'kg': 'kg',
    'kgs': 'kg',
    'kilo': 'kg',
    'kilos': 'kg',
    'kilogram': 'kg',
    'kilograms': 'kg',
    'lb': 'lb',
    'lbs': 'lb',
    'pound': 'lb',
    'pounds': 'lb',
  };

  CapturedSetDraft parse(String input) {
    final normalizedInput = input.trim();
    if (normalizedInput.isEmpty) {
      throw const TypedSetFormatException(
        'Enter a set phrase like "12 dips 30 kilos".',
      );
    }

    final tokens = normalizedInput
        .split(RegExp(r'\s+'))
        .map(_sanitizeToken)
        .where((token) => token.isNotEmpty)
        .toList();

    if (tokens.length < 2) {
      throw const TypedSetFormatException(
        'Start with reps followed by an exercise phrase.',
      );
    }

    final reps = int.tryParse(tokens.first);
    if (reps == null || reps <= 0) {
      throw const TypedSetFormatException(
        'Start the phrase with a positive rep count.',
      );
    }

    double? loadValue;
    String? loadUnit;
    var exerciseEndIndex = tokens.length;

    if (tokens.length >= 4) {
      final trailingUnit = _unitAliases[tokens.last.toLowerCase()];
      final trailingLoadValue = double.tryParse(tokens[tokens.length - 2]);
      if (trailingUnit != null && trailingLoadValue != null) {
        loadValue = trailingLoadValue;
        loadUnit = trailingUnit;
        exerciseEndIndex = tokens.length - 2;
      }
    }

    if (loadValue == null || loadUnit == null) {
      throw const TypedSetFormatException(
        'Finish the phrase with a load and unit, for example "30 kg".',
      );
    }

    final exerciseTokens = tokens.sublist(1, exerciseEndIndex);
    if (exerciseTokens.isEmpty) {
      throw const TypedSetFormatException(
        'Include an exercise phrase after the rep count.',
      );
    }

    final exercisePhrase = exerciseTokens.join(' ').trim();
    if (exercisePhrase.isEmpty) {
      throw const TypedSetFormatException(
        'Include an exercise phrase after the rep count.',
      );
    }

    return CapturedSetDraft(
      reps: reps,
      exercisePhrase: exercisePhrase,
      loadValue: loadValue,
      loadUnit: loadUnit,
    );
  }

  String _sanitizeToken(String token) {
    return token.replaceAll(RegExp(r'^[^a-zA-Z0-9]+|[^a-zA-Z0-9]+$'), '');
  }
}

class TypedSetFormatException implements Exception {
  const TypedSetFormatException(this.message);

  final String message;
}
