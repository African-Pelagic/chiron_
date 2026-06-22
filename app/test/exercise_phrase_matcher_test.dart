import 'package:chiron/src/features/session/data/exercise_phrase_matcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const matcher = ExercisePhraseMatcher();
  const candidates = <ExerciseResolutionCandidate>[
    ExerciseResolutionCandidate(
      id: 1,
      name: 'Pull Up',
      aliases: <String>['weighted pull up'],
    ),
    ExerciseResolutionCandidate(
      id: 2,
      name: 'Back Squat',
      aliases: <String>['barbell squat'],
    ),
  ];

  test('matches canonical names exactly ignoring case', () {
    final match = matcher.match('pull up', candidates);

    expect(match, isNotNull);
    expect(match!.exerciseId, 1);
    expect(match.canonicalName, 'Pull Up');
    expect(match.strategy, ExerciseMatchStrategy.exactCanonical);
  });

  test('matches aliases exactly before normalized canonical names', () {
    final match = matcher.match('weighted pull up', candidates);

    expect(match, isNotNull);
    expect(match!.exerciseId, 1);
    expect(match.canonicalName, 'Pull Up');
    expect(match.strategy, ExerciseMatchStrategy.exactAlias);
  });

  test('matches normalized aliases', () {
    final match = matcher.match('barbell-squat', candidates);

    expect(match, isNotNull);
    expect(match!.exerciseId, 2);
    expect(match.canonicalName, 'Back Squat');
    expect(match.strategy, ExerciseMatchStrategy.normalizedAlias);
  });

  test('matches normalized canonical names when punctuation is present', () {
    final match = matcher.match('pull up.', candidates);

    expect(match, isNotNull);
    expect(match!.exerciseId, 1);
    expect(match.canonicalName, 'Pull Up');
    expect(match.strategy, ExerciseMatchStrategy.normalizedCanonical);
  });

  test('matches pluralized exercise phrases through normalized singular forms', () {
    final match = matcher.match('pullups', candidates);

    expect(match, isNotNull);
    expect(match!.exerciseId, 1);
    expect(match.canonicalName, 'Pull Up');
    expect(match.strategy, ExerciseMatchStrategy.normalizedCanonical);
  });

  test('returns null when no candidate matches', () {
    final match = matcher.match('good morning', candidates);

    expect(match, isNull);
  });
}
