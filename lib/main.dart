import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/setup_profile_screen.dart';
import 'features/pos/pos_screen.dart';
import 'features/admin/admin_dashboard.dart';
import 'core/models/user_role.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: StouchiApp()));
}

class StouchiApp extends StatelessWidget {
  const StouchiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stouchi POS',
      theme: AppTheme.darkTheme,
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

            // Forced onboarding (only for non-admin users)
            if (profile.isFirstLogin && profile.role != UserRole.admin) {
              return const SetupProfileScreen();
            }
            
            if (profile.role == UserRole.admin) {
              return const AdminDashboard();
            } else {
              return const POSScreen();
            }
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, stack) => Scaffold(
            body: Center(child: Text('Error: $e')),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
