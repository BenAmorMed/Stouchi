import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import 'auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(userProfileProvider).value;
      if (profile != null) {
        _nameController.text = profile.name;
        _emailController.text = profile.email;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final profile = ref.read(userProfileProvider).value;
      
      bool needsReauth = (_emailController.text != profile?.email) || 
                        (_showPasswordFields && _newPasswordController.text.isNotEmpty);

      await ref.read(authServiceProvider).updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        currentPassword: needsReauth ? _currentPasswordController.text.trim() : null,
        newPassword: _showPasswordFields && _newPasswordController.text.isNotEmpty 
            ? _newPasswordController.text.trim() 
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      if (mounted) {
        String message = e.toString();
        if (message.contains('invalid-credential') || message.contains('wrong-password')) {
          message = 'The current password you entered is incorrect.';
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
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final themeMode = ref.watch(themeProvider);
                  final isDark = themeMode == ThemeMode.dark;
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: SwitchListTile(
                      title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(isDark ? 'Easy on the eyes' : 'Bright and clear'),
                      secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
                      value: isDark,
                      onChanged: (value) => ref.read(themeProvider.notifier).toggleTheme(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Security',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _showPasswordFields = !_showPasswordFields),
                    icon: Icon(_showPasswordFields ? Icons.close : Icons.lock_outline),
                    label: Text(_showPasswordFields ? 'Cancel Password Change' : 'Change Password'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (_showPasswordFields) ...[
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                  ),
                  obscureText: true,
                  validator: (val) => (val?.length ?? 0) < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: Icon(Icons.lock_clock_outlined),
                  ),
                  obscureText: true,
                  validator: (val) => val != _newPasswordController.text ? 'Passwords match required' : null,
                ),
                const SizedBox(height: 16),
              ],
              
              // Only show current password if modifying email or setting new password
              Consumer(builder: (context, ref, child) {
                final profile = ref.watch(userProfileProvider).value;
                bool needsReauth = (_emailController.text != profile?.email) || 
                                  (_showPasswordFields && _newPasswordController.text.isNotEmpty);
                
                if (needsReauth) {
                  return Column(
                    children: [
                      const Divider(height: 48),
                      const Text(
                        'Verification Required',
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your current password to save these sensitive changes.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _currentPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: Icon(Icons.security),
                        ),
                        obscureText: true,
                        validator: (val) => val?.isEmpty ?? true ? 'Required for verification' : null,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
              
              const SizedBox(height: 48),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Save Changes'),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: OutlinedButton.icon(
          onPressed: () {
            ref.read(authServiceProvider).signOut();
            Navigator.pop(context); // Close profile screen after logout
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign Out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size.fromHeight(56),
          ),
        ),
      ),
    );
  }
}
