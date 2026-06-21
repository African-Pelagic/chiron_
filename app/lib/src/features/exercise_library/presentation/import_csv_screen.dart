import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../application/exercise_library_controller.dart';
import '../data/csv_file_access.dart';

class ImportCsvScreen extends StatefulWidget {
  const ImportCsvScreen({
    super.key,
    required this.exerciseLibraryController,
    required this.csvFileAccess,
  });

  final ExerciseLibraryController exerciseLibraryController;
  final CsvFileAccess csvFileAccess;

  @override
  State<ImportCsvScreen> createState() => _ImportCsvScreenState();
}

class _ImportCsvScreenState extends State<ImportCsvScreen> {
  static const _schemaHeader = 'name,alias_1,alias_2,category,default_unit\n';

  late final TextEditingController _csvController;
  String? _fileActionMessage;

  @override
  void initState() {
    super.initState();
    _csvController = TextEditingController();
  }

  @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.exerciseLibraryController;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = ShadTheme.of(context);
        final importResult = controller.lastImportResult;

        return Scaffold(
          appBar: AppBar(title: const Text('CSV Import')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ShadCard(
                title: Text('Import exercise CSV', style: theme.textTheme.h3),
                description: Text(
                  'Choose a CSV from the device, inspect or edit it in place, then import it into the exercise catalog.',
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
                              unawaited(controller.importCsv(_csvController.text));
                            },
                      child: Text(
                        controller.isSaving ? 'Importing...' : 'Import CSV',
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _SchemaHint(theme: theme),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ShadButton(
                          onPressed: controller.isSaving
                              ? null
                              : () {
                                  unawaited(_pickCsv());
                                },
                          child: const Text('Upload From Device'),
                        ),
                        ShadButton.outline(
                          onPressed: controller.isSaving
                              ? null
                              : () {
                                  unawaited(_loadBundledSample());
                                },
                          child: const Text('Load Sample CSV'),
                        ),
                        ShadButton.outline(
                          onPressed: controller.isSaving
                              ? null
                              : () {
                                  unawaited(_downloadSchema());
                                },
                          child: const Text('Download Schema'),
                        ),
                      ],
                    ),
                    if (_fileActionMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _fileActionMessage!,
                        style: theme.textTheme.small,
                      ),
                    ],
                    const SizedBox(height: 20),
                    ShadInput(
                      controller: _csvController,
                      maxLines: 14,
                      placeholder: const Text(_schemaHeader),
                      onChanged: (_) => controller.clearError(),
                    ),
                  ],
                ),
              ),
              if (importResult != null) ...[
                const SizedBox(height: 16),
                ShadCard(
                  title: Text('Import summary', style: theme.textTheme.h4),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _SummaryLine(
                        label: 'Exercises created',
                        value: importResult.createdExercises,
                      ),
                      _SummaryLine(
                        label: 'Exercises updated',
                        value: importResult.updatedExercises,
                      ),
                      _SummaryLine(
                        label: 'Aliases added',
                        value: importResult.addedAliases,
                      ),
                      _SummaryLine(
                        label: 'Rows skipped',
                        value: importResult.skippedRows,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickCsv() async {
    final csvText = await widget.csvFileAccess.pickCsvText();
    if (!mounted || csvText == null) {
      return;
    }

    setState(() {
      _csvController.text = csvText;
      _fileActionMessage = 'Loaded CSV from the device.';
    });
  }

  Future<void> _loadBundledSample() async {
    final csv = await rootBundle.loadString('assets/examples/exercises.csv');
    if (!mounted) {
      return;
    }

    setState(() {
      _csvController.text = csv;
      _fileActionMessage = 'Loaded the bundled sample CSV.';
    });
  }

  Future<void> _downloadSchema() async {
    final savedPath = await widget.csvFileAccess.saveSchemaCsv(_schemaHeader);
    if (!mounted) {
      return;
    }

    setState(() {
      _fileActionMessage = savedPath == null
          ? 'Schema export was cancelled.'
          : 'Saved schema CSV to $savedPath';
    });
  }
}

class _SchemaHint extends StatelessWidget {
  const _SchemaHint({required this.theme});

  final ShadThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: const Text(
        'Expected headers: name, alias_1, alias_2, category, default_unit',
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.p)),
          Text(
            '$value',
            style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
