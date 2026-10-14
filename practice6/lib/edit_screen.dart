import 'package:flutter/material.dart';

import 'students.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.student});

  final Student student;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String _name = widget.student.name;
  bool _dialogOpen = false;

  bool get _dirty => _name != widget.student.name;

  Future<void> _confirmDiscard() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    _dialogOpen = false;
    if (discard == true && mounted && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_dirty,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _dirty) _confirmDiscard();
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Edit student')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Student name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _name = value),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_name),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
