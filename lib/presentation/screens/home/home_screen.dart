import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/mock_data.dart';
import '../../../providers/providers.dart';
import '../../widgets/section_header.dart';
import '../../widgets/salon_card.dart';
import '../../widgets/salon_list_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredSalons = ref.watch(featuredSalonsProvider);
    final nearbySalons = ref.watch(nearbySalonsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, Samantha', style: AppTextStyles.heading2),
                        const SizedBox(height: 4),

                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '360 Stillwater Rd, Palm City, FL',
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/search'),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Promo Banner
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width - 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=600',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black45,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Look more beautiful and\nsave more discount',
                                  style: AppTextStyles.bodySemiBold.copyWith(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Get offer now!',
                                    style: AppTextStyles.smallBold.copyWith(
                                      color: AppColors.accentDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Up to 50% badge
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Up to',
                                    style: AppTextStyles.small.copyWith(
                                      color: AppColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '50%',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'What do you want to do?',
                  style: AppTextStyles.subtitle,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _CategoryItem(icon: Icons.content_cut, label: 'Haircut'),
                    _CategoryItem(icon: Icons.brush, label: 'Nails'),
                    _CategoryItem(
                      icon: Icons.face_retouching_natural,
                      label: 'Facial',
                    ),
                    _CategoryItem(
                      icon: Icons.color_lens_outlined,
                      label: 'Coloring',
                    ),
                    _CategoryItem(icon: Icons.spa_outlined, label: 'Spa'),
                    _CategoryItem(icon: Icons.waves, label: 'Waxing'),
                    _CategoryItem(
                      icon: Icons.palette_outlined,
                      label: 'Makeup',
                    ),
                    _CategoryItem(
                      icon: Icons.self_improvement,
                      label: 'Massage',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upcoming Appointment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Upcoming Appointment',
                  style: AppTextStyles.subtitle,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF6B3A7D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plush Beauty Lounge',
                                    style: AppTextStyles.bodySemiBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Woman Medium Blunt Cut',
                                    style: AppTextStyles.small.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Status chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Tomorrow',
                                style: AppTextStyles.small.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Divider line
                        Container(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 14),
                        // Details row
                        Row(
                          children: [
                            // Date
                            _AppointmentDetail(
                              icon: Icons.event_rounded,
                              text: 'Tue, 26 Mar',
                            ),
                            const SizedBox(width: 20),
                            // Time
                            _AppointmentDetail(
                              icon: Icons.access_time_rounded,
                              text: '09:00 AM',
                            ),
                            const SizedBox(width: 20),
                            // Specialist
                            _AppointmentDetail(
                              icon: Icons.person_outline_rounded,
                              text: 'Ronald',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Featured Salon
              SectionHeader(
                title: 'Featured Salon',
                actionText: 'View all',
                onAction: () {},
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 265,
                child: featuredSalons.when(
                  data: (salons) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: salons.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SalonCard(
                          salon: salons[i],
                          onTap: () => context.push('/shop/${salons[i].id}'),
                        ),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
              const SizedBox(height: 24),

              // Most Search Interest
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Most Search Interest',
                  style: AppTextStyles.subtitle,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: MockData.serviceCategories.take(4).map((cat) {
                    const categoryIcons = {
                      'Haircut': Icons.content_cut,
                      'Nails': Icons.brush,
                      'Facial': Icons.face_retouching_natural,
                      'Coloring': Icons.color_lens_outlined,
                      'Spa': Icons.spa_outlined,
                      'Waxing': Icons.waves,
                      'Makeup': Icons.palette_outlined,
                      'Massage': Icons.self_improvement,
                    };
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              categoryIcons[cat] ?? Icons.content_cut,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cat,
                              style: AppTextStyles.captionMedium.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Nearby Offers
              SectionHeader(
                title: 'Nearby Offers',
                actionText: 'View all',
                onAction: () {},
              ),
              const SizedBox(height: 12),
              nearbySalons.when(
                data: (salons) => Column(
                  children: salons.take(3).map((salon) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SalonListTile(
                        salon: salon,
                        onTap: () => context.push('/shop/${salon.id}'),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Error: $e'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.small.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AppointmentDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AppointmentDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 16),
        const SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyles.small.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
