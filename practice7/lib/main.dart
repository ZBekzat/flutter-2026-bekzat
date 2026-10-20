import 'package:flutter/material.dart';

import 'summary_card.dart';

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice 7',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;
  int _passwordLength = 0;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _birthController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_agreed == false) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _done = true;
      });
    }
  }

  Future<void> _pickBirthDate() async {
    final today = DateTime.now();
    final firstDate = DateTime(1950);
    final initialDate = _birth ?? today;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: today,
    );

    if (selectedDate == null) {
      return;
    }
    if (mounted == false) {
      return;
    }

    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final dateText = '$day.$month.${selectedDate.year}';
    setState(() {
      _birth = selectedDate;
      _birthController.text = dateText;
    });
  }

  void _startOver() {
    _name.clear();
    _email.clear();
    _password.clear();
    _confirm.clear();
    _birthController.clear();
    setState(() {
      _group = null;
      _birth = null;
      _agreed = false;
      _passwordLength = 0;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SafeArea(child: _done ? _buildSummary() : _buildForm()),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    if ((value ?? '').trim().length < 2) {
                      return 'Enter at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  focusNode: _emailFocus,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'name@kbtu.kz',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    final email = (value ?? '').trim();
                    final atIndex = email.indexOf('@');
                    if (atIndex < 1 ||
                        email.substring(atIndex + 1).contains('.') == false) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    helperText: 'At least 8 characters',
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      _passwordLength = value.length;
                    });
                  },
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    if ((value ?? '').length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('$_passwordLength of 8'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirm,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    if ((value ?? '') == _password.text) {
                      return null;
                    }
                    return 'Passwords do not match';
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _group,
                  decoration: const InputDecoration(labelText: 'Group'),
                  items: [
                    for (final group in groups)
                      DropdownMenuItem(value: group, child: Text(group)),
                  ],
                  onChanged: (group) {
                    setState(() {
                      _group = group;
                    });
                  },
                  validator: (group) => group == null ? 'Choose a group' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _birthController,
                  decoration: const InputDecoration(
                    labelText: 'Date of birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _pickBirthDate,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (_) =>
                      _birth == null ? 'Choose your date of birth' : null,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I agree to the rules'),
                  value: _agreed,
                  onChanged: (agreed) {
                    setState(() {
                      _agreed = agreed ?? false;
                    });
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _agreed ? _submit : null,
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SummaryCard(
                name: _name.text.trim(),
                email: _email.text.trim(),
                group: _group ?? '',
                birthDate: _birthController.text,
              ),
              TextButton(
                onPressed: _startOver,
                child: const Text('Start over'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
