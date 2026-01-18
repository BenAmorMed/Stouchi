import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});
  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill name if already set by admin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(userProfileProvider).value;
      if (profile != null && profile.name != '(vide)') {
        _nameController.text = profile.name;
      }
    });
  }

    try {
      await ref.read(authServiceProvider).completeOnboarding(
        _nameController.text.trim(),
        _currentPasswordController.text.trim(),
        _passwordController.text.trim(),
      );
    } on Exception catch (e) {
      if (mounted) {
        String message = e.toString();
        if (message.contains('invalid-credential') || message.contains('wrong-password')) {
          message = 'The temporary password you entered is incorrect. Please use the password given by your administrator.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $message')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 64, color: Colors.blue),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to Stouchi!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please complete your profile specialized for your first login.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Temporary Password',
                      hintText: 'The password given by your administrator',
                      prefixIcon: Icon(Icons.key_rounded),
                    ),
                    obscureText: true,
                    validator: (val) => val?.isEmpty ?? true ? 'Required for verification' : null,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    // If name is pre-filled, we still want a strong password, 
                    // but the user might just want to keep their name.
                    validator: (val) => (val?.length ?? 0) < 6 ? 'Min 6 chars' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_clock_outlined),
                    ),
                    obscureText: true,
                    validator: (val) => val != _passwordController.text ? 'Passwords match required' : null,
                  ),
                  const SizedBox(height: 48),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Consumer(
                      builder: (context, ref, child) => ElevatedButton(
                        onPressed: () => _complete(ref),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text('Finish Setup'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
