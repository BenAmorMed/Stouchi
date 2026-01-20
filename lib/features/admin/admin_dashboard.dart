import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';
import 'category_management_screen.dart';
import 'article_management_screen.dart';
import 'user_management_screen.dart';
import '../statistics/admin_statistics_screen.dart';
import '../auth/profile_screen.dart';
import 'calendar/admin_calendar_screen.dart';
import 'stock/inventory_screen.dart';
import 'tables/table_layout_screen.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Stouchi Admin',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Management Console',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configure your menu and monitor performance',
              style: TextStyle(color: AppTheme.mutedTextColor),
            ),
            const SizedBox(height: 48),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9, // Taller cards to accommodate content
              children: [
                _AdminCard(
                  title: 'Categories',
                  subtitle: 'Menu sections',
                  icon: Icons.category_rounded,
                  color: AppTheme.primaryColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoryManagementScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'Articles',
                  subtitle: 'Products & coffee',
                  icon: Icons.inventory_2_rounded,
                  color: AppTheme.secondaryColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArticleManagementScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'Users',
                  subtitle: 'Access control',
                  icon: Icons.people_rounded,
                  color: Colors.amber,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'Statistics',
                  subtitle: 'Business insights',
                  icon: Icons.analytics_rounded,
                  color: AppTheme.accentColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminStatisticsScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'Inventory',
                  subtitle: 'Levels & Refills',
                  icon: Icons.inventory_rounded,
                  color: Colors.teal,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InventoryScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'My Profile',
                  subtitle: 'Account settings',
                  icon: Icons.manage_accounts_rounded,
                  color: Colors.indigoAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'Worker Schedule',
                  subtitle: 'Shifts & Calendar',
                  icon: Icons.calendar_month,
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminCalendarScreen()),
                  ),
                ),
                _AdminCard(
                  title: 'Table Layout',
                  subtitle: 'Map & Shapes',
                  icon: Icons.table_restaurant_rounded,
                  color: Colors.brown,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TableLayoutScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16), // Reduced padding
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.mutedTextColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10), // Reduced internal padding
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 28, color: color), // Slightly smaller icon
            ),
            const SizedBox(height: 12), // Use fixed spacing instead of spacer for small height
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
