import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/shared/widgets/julius_scaffold.dart';
import 'package:smart_collar_app/shared/widgets/teal_button.dart';

class PairCollarScreen extends StatefulWidget {
  const PairCollarScreen({super.key});

  @override
  State<PairCollarScreen> createState() => _PairCollarScreenState();
}

class _PairCollarScreenState extends State<PairCollarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceIdController = TextEditingController();

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return JuliusScaffold(
      appBar: AppBar(
        backgroundColor: kBgDeep,
        elevation: 0,
        title: const Text('Pair collar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Pair a collar device',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Scan the QR code on the collar or enter the device ID.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kTextSecond),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: kBgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kAccentSoft),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_scanner, color: kAccentPrimary),
                    const SizedBox(height: 8),
                    Text(
                      'QR scanning will be enabled with camera access.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: kTextSecond),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deviceIdController,
                decoration: const InputDecoration(labelText: 'Device ID'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Device ID required'
                    : null,
              ),
              const SizedBox(height: 24),
              TealButton.filled(
                label: 'Pair collar',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.go('/wifi-config');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
