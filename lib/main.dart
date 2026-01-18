import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/pos/pos_screen.dart';
import 'features/admin/admin_dashboard.dart';
import 'core/models/user_role.dart';
import 'firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const StouchiApp(),
  ));
}

class StouchiApp extends ConsumerWidget {
  const StouchiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Stouchi POS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        
        // Fetch user profile to determine role and onboarding status
        final profileAsync = ref.watch(userProfileProvider);
        
        return profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Scaffold(
                body: Center(child: Text('User profile not found')),
              );
            }

            // Non-blocking onboarding: 
            // We follow the user request: "connect first to dashboard after that prompt pop up"
            
            if (profile.role == UserRole.admin) {
              return const AdminDashboard();
            } else {
              return const POSScreen();
            }
          },
          loading: () => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Loading profile...'),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => ref.read(authServiceProvider).signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
          error: (e, stack) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading profile: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(authServiceProvider).signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
