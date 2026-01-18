import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/models/user_role.dart';
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
  late UserRole _role;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _role = widget.user?.role ?? UserRole.server;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (widget.user == null) {
        // CREATE NEW USER
        // IMPORTANT: We use a secondary Firebase App to create a user 
        // without logging out the current admin.
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
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toJson());
        
        await app.delete(); // Important to clean up
      } else {
        // UPDATE EXISTING USER
        final updatedUser = widget.user!.copyWith(
          name: _nameController.text.trim().isEmpty ? '(vide)' : _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _role,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user!.id)
            .update(updatedUser.toJson());
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
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
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Optional - defaults to (vide)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                enabled: widget.user == null, // Can't change email easily in Auth
                validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
              ),
              if (widget.user == null) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Temporary Password',
                    hintText: 'User must change this on first login',
                  ),
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
              const SizedBox(height: 48),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Save User'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
