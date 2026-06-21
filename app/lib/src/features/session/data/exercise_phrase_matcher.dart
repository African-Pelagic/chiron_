class ExercisePhraseMatcher {
  const ExercisePhraseMatcher();

  ResolvedExerciseMatch? match(
    String phrase,
    List<ExerciseResolutionCandidate> candidates,
  ) {
    final exactPhrase = _exactKey(phrase);
    final normalizedPhraseForms = _normalizedForms(phrase);

    for (final candidate in candidates) {
      if (_exactKey(candidate.name) == exactPhrase) {
        return ResolvedExerciseMatch(
          exerciseId: candidate.id,
          canonicalName: candidate.name,
          matchedText: candidate.name,
          strategy: ExerciseMatchStrategy.exactCanonical,
        );
      }
    }

    for (final candidate in candidates) {
      for (final alias in candidate.aliases) {
        if (_exactKey(alias) == exactPhrase) {
          return ResolvedExerciseMatch(
            exerciseId: candidate.id,
            canonicalName: candidate.name,
            matchedText: alias,
            strategy: ExerciseMatchStrategy.exactAlias,
          );
        }
      }
    }

    for (final candidate in candidates) {
      if (_normalizedForms(candidate.name).any(normalizedPhraseForms.contains)) {
        return ResolvedExerciseMatch(
          exerciseId: candidate.id,
          canonicalName: candidate.name,
          matchedText: candidate.name,
          strategy: ExerciseMatchStrategy.normalizedCanonical,
        );
      }
    }

    for (final candidate in candidates) {
      for (final alias in candidate.aliases) {
        if (_normalizedForms(alias).any(normalizedPhraseForms.contains)) {
          return ResolvedExerciseMatch(
            exerciseId: candidate.id,
            canonicalName: candidate.name,
            matchedText: alias,
            strategy: ExerciseMatchStrategy.normalizedAlias,
          );
        }
      }
    }

    return null;
  }

  String _exactKey(String value) {
    return value.trim().toLowerCase();
  }

  String _normalizedKey(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  Set<String> _normalizedForms(String value) {
    final normalized = _normalizedKey(value);
    if (normalized.isEmpty) {
      return const <String>{};
    }

    final singularized = _singularizeNormalizedKey(normalized);
    if (singularized == normalized) {
      return <String>{normalized};
    }

    return <String>{normalized, singularized};
  }

  String _singularizeNormalizedKey(String normalized) {
    if (normalized.length <= 3) {
      return normalized;
    }

    if (normalized.endsWith('ies') && normalized.length > 4) {
      return '${normalized.substring(0, normalized.length - 3)}y';
    }

    if (normalized.endsWith('ches') ||
        normalized.endsWith('shes') ||
        normalized.endsWith('sses') ||
        normalized.endsWith('xes') ||
        normalized.endsWith('zes')) {
      return normalized.substring(0, normalized.length - 2);
    }

    if (normalized.endsWith('s') && !normalized.endsWith('ss')) {
      return normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }
}

class ExerciseResolutionCandidate {
  const ExerciseResolutionCandidate({
    required this.id,
    required this.name,
    required this.aliases,
  });

  final int id;
  final String name;
  final List<String> aliases;
}

class ResolvedExerciseMatch {
  const ResolvedExerciseMatch({
    required this.exerciseId,
    required this.canonicalName,
    required this.matchedText,
    required this.strategy,
  });

  final int exerciseId;
  final String canonicalName;
  final String matchedText;
  final ExerciseMatchStrategy strategy;
}

class UnresolvedExercisePhraseException implements Exception {
  const UnresolvedExercisePhraseException(this.phrase);

  final String phrase;
}

enum ExerciseMatchStrategy {
  exactCanonical,
  exactAlias,
  normalizedCanonical,
  normalizedAlias,
}
