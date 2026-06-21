import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../application/exercise_library_controller.dart';
import '../domain/exercise_definition.dart';

class ExerciseEditorScreen extends StatefulWidget {
  const ExerciseEditorScreen({
    super.key,
    required this.exerciseLibraryController,
    this.exercise,
  });

  final ExerciseLibraryController exerciseLibraryController;
  final ExerciseDefinition? exercise;

  @override
  State<ExerciseEditorScreen> createState() => _ExerciseEditorScreenState();
}

class _ExerciseEditorScreenState extends State<ExerciseEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _unitController;
  late final TextEditingController _aliasesController;
  late bool _isActive;

  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    final exercise = widget.exercise;
    _nameController = TextEditingController(text: exercise?.name ?? '');
    _categoryController = TextEditingController(text: exercise?.category ?? '');
    _unitController = TextEditingController(text: exercise?.defaultUnit ?? '');
    _aliasesController = TextEditingController(
      text: exercise?.aliases.join(', ') ?? '',
    );
    _isActive = exercise?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    _aliasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.exerciseLibraryController;
    final theme = ShadTheme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit Exercise' : 'Add Exercise'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ShadCard(
                title: Text(
                  _isEditing ? 'Exercise record' : 'New exercise record',
                  style: theme.textTheme.h4,
                ),
                description: Text(
                  'Edit every available exercise-record field before saving it into the local catalog.',
                  style: theme.textTheme.muted,
                ),
                footer: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.errorMessage case final message?) ...[
                      Text(
                        message,
                        style: TextStyle(color: theme.colorScheme.destructive),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ShadButton(
                      onPressed: controller.isSaving
                          ? null
                          : () {
                              unawaited(_save());
                            },
                      child: Text(
                        controller.isSaving
                            ? 'Saving...'
                            : _isEditing
                            ? 'Save Exercise'
                            : 'Create Exercise',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShadButton.outline(
                      onPressed: controller.isSaving
                          ? null
                          : () {
                              Navigator.of(context).maybePop();
                            },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _FieldLabel(label: 'Name'),
                    const SizedBox(height: 8),
                    ShadInput(
                      controller: _nameController,
                      placeholder: const Text('Pull Up'),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Category'),
                    const SizedBox(height: 8),
                    ShadInput(
                      controller: _categoryController,
                      placeholder: const Text('pull'),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Default unit'),
                    const SizedBox(height: 8),
                    ShadInput(
                      controller: _unitController,
                      placeholder: const Text('kg'),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Aliases'),
                    const SizedBox(height: 8),
                    ShadInput(
                      controller: _aliasesController,
                      placeholder: const Text('pullup, weighted pull up'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ShadSwitch(
                      value: _isActive,
                      onChanged: controller.isSaving
                          ? null
                          : (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                      label: const Text('Active'),
                      sublabel: const Text(
                        'Inactive exercises stay in the catalog but are excluded from active matching.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final controller = widget.exerciseLibraryController;
    final exercise = widget.exercise;

    if (exercise == null) {
      await controller.createExercise(
        name: _nameController.text,
        category: _categoryController.text,
        defaultUnit: _unitController.text,
        isActive: _isActive,
        aliases: _parseAliases(),
      );
    } else {
      await controller.updateExercise(
        id: exercise.id,
        name: _nameController.text,
        category: _categoryController.text,
        defaultUnit: _unitController.text,
        isActive: _isActive,
        aliases: _parseAliases(),
      );
    }

    if (!mounted || controller.errorMessage != null) {
      return;
    }

    Navigator.of(context).pop();
  }

  List<String> _parseAliases() {
    return _aliasesController.text
        .split(',')
        .map((alias) => alias.trim())
        .where((alias) => alias.isNotEmpty)
        .toList(growable: false);
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Text(
      label,
      style: theme.textTheme.small.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.mutedForeground,
      ),
    );
  }
}
