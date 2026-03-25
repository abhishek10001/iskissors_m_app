import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';
import '../../../data/repositories/mock_data.dart';

class ShopDetailsScreen extends ConsumerStatefulWidget {
  final String salonId;
  const ShopDetailsScreen({super.key, required this.salonId});

  @override
  ConsumerState<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends ConsumerState<ShopDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salonAsync = ref.watch(salonDetailProvider(widget.salonId));
    final reviewsAsync = ref.watch(reviewsProvider(widget.salonId));
    final galleryAsync = ref.watch(galleryProvider(widget.salonId));

    return salonAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (salon) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // Hero Image
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textDark),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share, size: 16, color: AppColors.textDark),
                  ),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(imageUrl: salon.imageUrl, fit: BoxFit.cover),
                    Positioned(
                      bottom: 16, left: 16,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: salon.isOpen ? AppColors.success : AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 6, color: AppColors.white),
                                const SizedBox(width: 6),
                                Text(salon.isOpen ? 'Open' : 'Closed', style: AppTextStyles.small.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          if (salon.paxAvailable > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('${salon.paxAvailable} pax available today', style: AppTextStyles.small.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name, categories, address
                    Text(salon.categories.join(' . '), style: AppTextStyles.small.copyWith(color: AppColors.primary)),
                    const SizedBox(height: 8),
                    Text(salon.name, style: AppTextStyles.heading2),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Expanded(child: Text(salon.address, style: AppTextStyles.caption)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Stats
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.star, size: 18),
                        const SizedBox(width: 4),
                        Text('${salon.rating}', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                        Text(' (${_fmt(salon.reviewCount)} Reviews)', style: AppTextStyles.caption),
                        const Spacer(),
                        const Icon(Icons.visibility_outlined, size: 16, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text('${_fmt(salon.viewCount)}', style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        _ActionButton(icon: Icons.phone, label: 'Call', onTap: () {}),
                        const SizedBox(width: 12),
                        _ActionButton(icon: Icons.chat_bubble_outline, label: 'Message', onTap: () => context.push('/chat/${widget.salonId}?name=${Uri.encodeComponent(salon.name)}&image=${Uri.encodeComponent(salon.imageUrl)}')),
                        const SizedBox(width: 12),
                        _ActionButton(icon: Icons.navigation_outlined, label: 'Direction', onTap: () {}),
                        const SizedBox(width: 12),
                        _ActionButton(icon: Icons.share, label: 'Share', onTap: () {}),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // About
                    Text('About', style: AppTextStyles.subtitle),
                    const SizedBox(height: 8),
                    Text(
                      salon.about.isNotEmpty ? salon.about : 'A premier salon offering high-quality beauty services with skilled professionals.',
                      style: AppTextStyles.caption.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 16),

                    // Opening hours
                    Text('Opening Hours', style: AppTextStyles.subtitle),
                    const SizedBox(height: 8),
                    if (salon.openingHours.isNotEmpty)
                      ...salon.openingHours.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.key, style: AppTextStyles.caption),
                            Text(e.value, style: AppTextStyles.captionMedium.copyWith(color: AppColors.textDark)),
                          ],
                        ),
                      )),
                    if (salon.openingHours.isEmpty)
                      ...[
                        _hoursRow('Monday - Friday', '08:00am - 03:00pm'),
                        _hoursRow('Saturday - Sunday', '09:00am - 02:00pm'),
                      ],
                    const SizedBox(height: 24),

                    // Services tabs
                    Text('Our services', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Service tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textGrey,
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Haircut'),
                    Tab(text: 'Facial'),
                    Tab(text: 'Nails'),
                  ],
                ),
              ),
            ),

            // Service items (showing haircuts by default)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: MockData.hairServices.take(3).map((service) {
                    return _ServiceItem(
                      name: service.name,
                      price: '\$${service.price.toInt()}',
                      originalPrice: service.originalPrice != service.price ? '\$${service.originalPrice.toInt()}' : null,
                      duration: service.duration,
                      imageUrl: service.imageUrl,
                      onTap: () {},
                    );
                  }).toList(),
                ),
              ),
            ),

            // View All
            SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => context.push('/services/${widget.salonId}'),
                  child: Text('View All Service', style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.primary)),
                ),
              ),
            ),

            // Gallery
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gallery', style: AppTextStyles.subtitle),
                        Text('View all', style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    galleryAsync.when(
                      data: (images) => SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(imageUrl: images[i], width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      loading: () => const SizedBox(height: 100),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // Specialist
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our Specialist', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.specialists.length,
                        itemBuilder: (_, i) {
                          final sp = MockData.specialists[i];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                CircleAvatar(radius: 28, backgroundImage: CachedNetworkImageProvider(sp.imageUrl)),
                                const SizedBox(height: 4),
                                Text(sp.name, style: AppTextStyles.small.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Reviews
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reviews', style: AppTextStyles.subtitle),
                        Text('View all', style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    reviewsAsync.when(
                      data: (reviews) => Column(
                        children: reviews.map((r) => _ReviewItem(review: r)).toList(),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
        // Bottom bar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.push('/services/${widget.salonId}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: Text('Book Now', style: AppTextStyles.button),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

Widget _hoursRow(String day, String hours) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: AppTextStyles.caption),
        Text(hours, style: AppTextStyles.captionMedium.copyWith(color: AppColors.textDark)),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.small.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String name;
  final String price;
  final String? originalPrice;
  final String duration;
  final String imageUrl;
  final VoidCallback onTap;

  const _ServiceItem({required this.name, required this.price, this.originalPrice, required this.duration, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(imageUrl: imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(price, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: AppColors.primary)),
                    if (originalPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(originalPrice!, style: AppTextStyles.caption.copyWith(decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
                Text(duration, style: AppTextStyles.small),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textGrey),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final dynamic review;
  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, backgroundImage: CachedNetworkImageProvider(review.userImage)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.userName, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                    Text(review.time, style: AppTextStyles.small),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < review.rating.floor() ? Icons.star : (i < review.rating ? Icons.star_half : Icons.star_border),
                    color: AppColors.star, size: 16,
                  )),
                ),
                const SizedBox(height: 8),
                Text(review.comment, style: AppTextStyles.caption.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
