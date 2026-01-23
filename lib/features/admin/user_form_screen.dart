import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/user_model.dart';
import '../../core/models/user_role.dart';
import '../../core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _hourlyRateController;
  late TextEditingController _baseSalaryController;
  late UserRole _role;
  late SalaryType _salaryType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _hourlyRateController = TextEditingController(text: widget.user?.hourlyRate.toString() ?? '0.0');
    _baseSalaryController = TextEditingController(text: widget.user?.baseSalary.toString() ?? '0.0');
    _role = widget.user?.role ?? UserRole.server;
    _salaryType = widget.user?.salaryType ?? SalaryType.hourly;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _hourlyRateController.dispose();
    _baseSalaryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final hourlyRate = double.tryParse(_hourlyRateController.text) ?? 0.0;
      final baseSalary = double.tryParse(_baseSalaryController.text) ?? 0.0;

      if (widget.user == null) {
        // CREATE NEW USER
        FirebaseApp app = await Firebase.initializeApp(
          name: 'SecondaryApp',
          options: DefaultFirebaseOptions.currentPlatform,
        );
        
        UserCredential cred = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final newUser = UserModel(
          id: cred.user!.uid,
          name: _nameController.text.trim().isEmpty ? '(vide)' : _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _role,
          isFirstLogin: true, 
          hourlyRate: hourlyRate,
          baseSalary: baseSalary,
          salaryType: _salaryType,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toJson());
        
        await app.delete(); 
      } else {
        // UPDATE EXISTING USER
        final updatedUser = widget.user!.copyWith(
          name: _nameController.text.trim().isEmpty ? '(vide)' : _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _role,
          hourlyRate: hourlyRate,
          baseSalary: baseSalary,
          salaryType: _salaryType,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.id)
            .update(updatedUser.toJson());
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user == null ? 'Add User' : 'Edit User')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                enabled: widget.user == null,
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
              if (widget.user == null) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Temporary Password'),
                  obscureText: true,
                  validator: (val) => (val?.length ?? 0) < 6 ? 'Min 6 chars' : null,
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: UserRole.values.map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role.name.toUpperCase()),
                )).toList(),
                onChanged: (val) => setState(() => _role = val!),
              ),
              
              const Divider(height: 48),
              Card(
                elevation: 0,
                color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppTheme.mutedTextColor.withValues(alpha: 0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payments_rounded, color: AppTheme.primaryColor),
                          const SizedBox(width: 12),
                          Text(
                            'Salary Configuration',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Payment Structure',
                        style: TextStyle(color: AppTheme.mutedTextColor, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<SalaryType>(
                          segments: const [
                            ButtonSegment(
                              value: SalaryType.hourly,
                              label: Text('Hourly'),
                              icon: Icon(Icons.timer_outlined, size: 18),
                            ),
                            ButtonSegment(
                              value: SalaryType.fixed,
                              label: Text('Fixed'),
                              icon: Icon(Icons.calendar_today_outlined, size: 18),
                            ),
                            ButtonSegment(
                              value: SalaryType.both,
                              label: Text('Both'),
                              icon: Icon(Icons.add_chart_rounded, size: 18),
                            ),
                          ],
                          selected: {_salaryType},
                          onSelectionChanged: (Set<SalaryType> newSelection) {
                            setState(() => _salaryType = newSelection.first);
                          },
                          style: SegmentedButton.styleFrom(
                            selectedBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                            selectedForegroundColor: AppTheme.primaryColor,
                            side: BorderSide(color: AppTheme.mutedTextColor.withValues(alpha: 0.1)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('hourly_rate_field'),
                              controller: _hourlyRateController,
                              enabled: _salaryType == SalaryType.hourly || _salaryType == SalaryType.both,
                              decoration: InputDecoration(
                                labelText: 'Hourly Rate',
                                prefixIcon: const Icon(Icons.attach_money_rounded, size: 20),
                                hintText: '0.00',
                                fillColor: (_salaryType == SalaryType.fixed) 
                                    ? Colors.black26 
                                    : AppTheme.surfaceColor,
                                filled: true,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('base_salary_field'),
                              controller: _baseSalaryController,
                              enabled: _salaryType == SalaryType.fixed || _salaryType == SalaryType.both,
                              decoration: InputDecoration(
                                labelText: 'Base Pay',
                                prefixIcon: const Icon(Icons.account_balance_wallet_rounded, size: 20),
                                hintText: '0.00',
                                fillColor: (_salaryType == SalaryType.hourly) 
                                    ? Colors.black26 
                                    : AppTheme.surfaceColor,
                                filled: true,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      if (_salaryType == SalaryType.both)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'Staff will receive base pay + hourly rate.',
                            style: TextStyle(
                              color: AppTheme.secondaryColor.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                  child: const Text('Save User'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
