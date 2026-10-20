import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pagesController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      pages: int.parse(_pagesController.text.trim()),
      year: int.tryParse(_yearController.text.trim()),
      read: false,
    );
    Navigator.pop(context, book);
  }

  String? _yearValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final year = int.tryParse(text);
    if (year == null || year < 1450 || year > DateTime.now().year) {
      return 'Enter a year from 1450 to ${DateTime.now().year}';
    }
    return null;
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    required TextInputAction textInputAction,
    bool isLast = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onFieldSubmitted: isLast ? (_) => _save() : null,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a book')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _field(
                controller: _titleController,
                label: 'Title',
                textInputAction: TextInputAction.next,
                validator: (value) => (value?.trim().length ?? 0) < 2
                    ? 'Enter at least two characters'
                    : null,
              ),
              _field(
                controller: _authorController,
                label: 'Author',
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Enter an author' : null,
              ),
              _field(
                controller: _pagesController,
                label: 'Pages',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final pages = int.tryParse(value?.trim() ?? '');
                  return pages == null || pages <= 0
                      ? 'A whole number above 0'
                      : null;
                },
              ),
              _field(
                controller: _yearController,
                label: 'Year (optional)',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: _yearValidator,
                isLast: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
