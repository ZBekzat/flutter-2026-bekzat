import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _value = 0;
  bool _saving = false;

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _saving = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: _value == 0
                    ? null
                    : () {
                        setState(() {
                          _value--;
                        });
                      },
                child: const Text('−'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('$_value'),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _value++;
                  });
                },
                child: const Text('+'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    ),
  );
}
