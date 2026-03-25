import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person, size: 52, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit, size: 16, color: AppColors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Samantha', style: AppTextStyles.heading3),
              Text('samantha@email.com', style: AppTextStyles.caption),
              const SizedBox(height: 32),

              // Menu items
              _ProfileMenuItem(icon: Icons.person_outline, title: 'Edit Profile', onTap: () {}),
              _ProfileMenuItem(icon: Icons.favorite_border, title: 'Favorites', onTap: () {}),
              _ProfileMenuItem(icon: Icons.payment, title: 'Payment Methods', onTap: () {}),
              _ProfileMenuItem(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () {}),
              _ProfileMenuItem(icon: Icons.settings_outlined, title: 'Settings', onTap: () {}),
              _ProfileMenuItem(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
              const SizedBox(height: 16),
              _ProfileMenuItem(
                icon: Icons.logout,
                title: 'Log Out',
                color: AppColors.error,
                onTap: () => context.go('/login'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textDark;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: c, size: 22),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: c)),
      trailing: Icon(Icons.chevron_right, color: c.withValues(alpha: 0.5)),
    );
  }
}
