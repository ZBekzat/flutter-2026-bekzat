import 'package:flutter/material.dart';

import '../models/item.dart';
import '../routes.dart';

class RunFormScreen extends StatefulWidget {
  const RunFormScreen({super.key, required this.arguments});

  final RunFormArguments arguments;

  @override
  State<RunFormScreen> createState() => _RunFormScreenState();
}

class _RunFormScreenState extends State<RunFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _locationFocus = FocusNode();
  final _limitFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _timeFocus = FocusNode();

  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _limitController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;

  RunCategory? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isOnline = false;
  bool _isSaving = false;
  bool _allowPop = false;
  bool _discardDialogOpen = false;

  Item? get _originalItem => widget.arguments.item;

  @override
  void initState() {
    super.initState();
    final item = _originalItem;
    _titleController = TextEditingController(text: item?.title ?? '');
    _locationController = TextEditingController(text: item?.location ?? '');
    _limitController = TextEditingController(
      text: item == null ? '' : item.participantLimit.toString(),
    );
    _descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    _dateController = TextEditingController(
      text: item == null ? '' : _formatDate(item.dateTime),
    );
    _timeController = TextEditingController(
      text: item == null
          ? ''
          : _formatTime(TimeOfDay.fromDateTime(item.dateTime)),
    );
    _selectedCategory = item?.category;
    _selectedDate = item?.dateTime;
    _selectedTime = item == null ? null : TimeOfDay.fromDateTime(item.dateTime);
    _isOnline = item?.isOnline ?? false;
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  bool _sameDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) {
      return first == second;
    }
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _sameTime(TimeOfDay? first, TimeOfDay? second) {
    if (first == null || second == null) {
      return first == second;
    }
    return first.hour == second.hour && first.minute == second.minute;
  }

  DateTime? get _combinedDateTime {
    final date = _selectedDate;
    final time = _selectedTime;
    if (date == null || time == null) {
      return null;
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool get _isDirty {
    final item = _originalItem;
    return _titleController.text != (item?.title ?? '') ||
        _locationController.text != (item?.location ?? '') ||
        _limitController.text !=
            (item == null ? '' : item.participantLimit.toString()) ||
        _descriptionController.text != (item?.description ?? '') ||
        _selectedCategory != item?.category ||
        !_sameDate(_selectedDate, item?.dateTime) ||
        !_sameTime(
          _selectedTime,
          item == null ? null : TimeOfDay.fromDateTime(item.dateTime),
        ) ||
        _isOnline != (item?.isOnline ?? false);
  }

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) {
      return 'Enter a title.';
    }
    if (title.length < 3 || title.length > 60) {
      return 'Use between 3 and 60 characters.';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    final location = value?.trim() ?? '';
    if (location.isEmpty) {
      return _isOnline ? 'Enter a meeting link.' : 'Enter a meeting place.';
    }
    if (_isOnline && !location.contains('://')) {
      return 'The meeting link must contain ://.';
    }
    return null;
  }

  String? _validateLimit(String? value) {
    final limit = int.tryParse(value?.trim() ?? '');
    if (limit == null || limit < 1 || limit > 500) {
      return 'Enter a whole number from 1 to 500.';
    }
    final participantCount = _originalItem?.count ?? 0;
    if (limit < participantCount) {
      return 'Limit cannot be below $participantCount participants.';
    }
    return null;
  }

  String? _validateDate(String? value) =>
      _selectedDate == null ? 'Choose a date.' : null;

  String? _validateTime(String? value) {
    final dateTime = _combinedDateTime;
    if (dateTime == null) {
      return 'Choose a time.';
    }
    if (_originalItem == null && !dateTime.isAfter(DateTime.now())) {
      return 'Choose a future date and time.';
    }
    return null;
  }

  Future<void> _chooseDate() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final item = _originalItem;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year, now.month, now.day + 1),
      firstDate: item == null
          ? DateTime(now.year, now.month, now.day)
          : DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (!mounted || pickedDate == null) {
      return;
    }
    setState(() {
      _selectedDate = pickedDate;
      _dateController.text = _formatDate(pickedDate);
    });
  }

  Future<void> _chooseTime() async {
    FocusScope.of(context).unfocus();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (!mounted || pickedTime == null) {
      return;
    }
    setState(() {
      _selectedTime = pickedTime;
      _timeController.text = _formatTime(pickedTime);
    });
  }

  Future<void> _save() async {
    if (_isSaving) {
      return;
    }
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final category = _selectedCategory;
    final dateTime = _combinedDateTime;
    final participantLimit = int.tryParse(_limitController.text.trim());
    if (category == null || dateTime == null || participantLimit == null) {
      return;
    }

    final descriptionText = _descriptionController.text.trim();
    final description = descriptionText.isEmpty ? null : descriptionText;
    final item = _originalItem;
    final result = item == null
        ? Item(
            title: _titleController.text.trim(),
            category: category,
            dateTime: dateTime,
            location: _locationController.text.trim(),
            participantLimit: participantLimit,
            participants: const [],
            isOnline: _isOnline,
            description: description,
          )
        : item.copyWith(
            title: _titleController.text.trim(),
            category: category,
            dateTime: dateTime,
            location: _locationController.text.trim(),
            participantLimit: participantLimit,
            isOnline: _isOnline,
            description: description,
            clearDescription: description == null,
          );

    setState(() {
      _isSaving = true;
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }
    Navigator.pop<Item>(context, result);
  }

  Future<void> _confirmDiscard() async {
    if (!mounted || _isSaving || _discardDialogOpen || !_isDirty) {
      return;
    }
    setState(() {
      _discardDialogOpen = true;
    });

    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _discardDialogOpen = false;
    });
    if (discard != true) {
      return;
    }
    setState(() {
      _allowPop = true;
    });
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }
    Navigator.pop<Item>(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _limitController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _titleFocus.dispose();
    _locationFocus.dispose();
    _limitFocus.dispose();
    _descriptionFocus.dispose();
    _dateFocus.dispose();
    _timeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _originalItem;

    return PopScope<Item>(
      canPop: !_isDirty || _isSaving || _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isSaving && !_allowPop) {
          _confirmDiscard();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(item == null ? 'Create a run' : 'Edit run')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: AbsorbPointer(
            absorbing: _isSaving,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    focusNode: _titleFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      labelText: 'Run title',
                      hintText: 'Easy Morning 5K',
                    ),
                    validator: _validateTitle,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (_) => setState(() {}),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_locationFocus),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<RunCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      for (final category in RunCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                    ],
                    validator: (category) =>
                        category == null ? 'Choose a category.' : null,
                    onChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Online run'),
                    subtitle: Text(
                      _isOnline
                          ? 'Participants will join by meeting link.'
                          : 'Participants will meet at a place.',
                    ),
                    value: _isOnline,
                    onChanged: (value) => setState(() => _isOnline = value),
                  ),
                  TextFormField(
                    controller: _locationController,
                    focusNode: _locationFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: _isOnline ? 'Meeting link' : 'Meeting place',
                      hintText: _isOnline
                          ? 'https://example.com/meet'
                          : 'Park entrance or trailhead',
                    ),
                    validator: _validateLocation,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (_) => setState(() {}),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_limitFocus),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _limitController,
                    focusNode: _limitFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Participant limit',
                      hintText: '10',
                    ),
                    validator: _validateLimit,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (_) => setState(() {}),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_descriptionFocus),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          focusNode: _dateFocus,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          validator: _validateDate,
                          onTap: _chooseDate,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          focusNode: _timeFocus,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Time',
                            suffixIcon: Icon(Icons.schedule),
                          ),
                          validator: _validateTime,
                          onTap: _chooseTime,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocus,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) => null,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(item == null ? 'Create run' : 'Save changes'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
