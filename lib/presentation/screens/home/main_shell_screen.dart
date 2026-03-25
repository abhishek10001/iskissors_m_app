import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/providers.dart';
import '../../widgets/allow_location_dialog.dart';
import 'home_screen.dart';
import '../nearby/nearby_screen.dart';
import '../booking/calendar_screen.dart';
import '../messages/messages_screen.dart';
import '../profile/profile_screen.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  bool _locationDialogShown = false;

  @override
  void initState() {
    super.initState();
    // Show Allow Location dialog once when the home screen first appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_locationDialogShown && mounted) {
        _locationDialogShown = true;
        AllowLocationDialog.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = const [
      HomeScreen(),
      NearbyScreen(),
      CalendarScreen(),
      MessagesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  isSelected: currentIndex == 0,
                  onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 0,
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  isSelected: currentIndex == 1,
                  onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
                ),
                _NavItem(
                  icon: Icons.calendar_month_outlined,
                  isSelected: currentIndex == 2,
                  onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2,
                ),
                _NavItem(
                  icon: Icons.chat_bubble_outline,
                  isSelected: currentIndex == 3,
                  onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3,
                  showBadge: true,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  isSelected: currentIndex == 4,
                  onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBadge;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.textGrey,
                  size: 26,
                ),
                if (showBadge)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
