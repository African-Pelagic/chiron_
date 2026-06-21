class ExerciseDefinition {
  const ExerciseDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultUnit,
    required this.isActive,
    required this.aliases,
  });

  final int id;
  final String name;
  final String category;
  final String defaultUnit;
  final bool isActive;
  final List<String> aliases;
}
