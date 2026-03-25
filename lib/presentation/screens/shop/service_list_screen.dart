import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/mock_data.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';

class ServiceListScreen extends ConsumerStatefulWidget {
  final String salonId;
  const ServiceListScreen({super.key, required this.salonId});

  @override
  ConsumerState<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends ConsumerState<ServiceListScreen> {
  String _activeCategory = 'Haircut';

  @override
  Widget build(BuildContext context) {
    final selectedServices = ref.watch(selectedServicesProvider);
    final notifier = ref.read(selectedServicesProvider.notifier);

    final List<ServiceModel> services;
    switch (_activeCategory) {
      case 'Facial':
        services = MockData.facialServices;
        break;
      case 'Nails':
        services = MockData.nailServices;
        break;
      default:
        services = MockData.hairServices;
    }

    final totalPrice = selectedServices.fold<double>(0, (sum, s) => sum + s.price);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Our Services'),
      ),
      body: Column(
        children: [
          // Category tabs
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Haircut', 'Facial', 'Nails', 'Coloring', 'Spa'].map((cat) {
                final isActive = cat == _activeCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _activeCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : Colors.transparent,
                        border: Border.all(color: isActive ? AppColors.primary : AppColors.divider),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Text(cat, style: AppTextStyles.captionMedium.copyWith(color: isActive ? AppColors.white : AppColors.textDark)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Services list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: services.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (_, i) {
                final s = services[i];
                final isSelected = selectedServices.any((ss) => ss.id == s.id);
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(imageUrl: s.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('\$${s.price.toInt()}', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: AppColors.primary)),
                              if (s.originalPrice != s.price) ...[
                                const SizedBox(width: 8),
                                Text('\$${s.originalPrice.toInt()}', style: AppTextStyles.caption.copyWith(decoration: TextDecoration.lineThrough)),
                              ],
                            ],
                          ),
                          Text(s.duration, style: AppTextStyles.small),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          notifier.removeService(s);
                        } else {
                          notifier.addService(s);
                        }
                      },
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected ? Icons.check : Icons.add,
                          color: isSelected ? AppColors.white : AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Bottom bar
          if (selectedServices.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${selectedServices.length} Service Selected', style: AppTextStyles.caption),
                        Text('\$${totalPrice.toInt()}', style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.push('/booking/${widget.salonId}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          minimumSize: const Size(0, 48),
                        ),
                        child: Text('Book Now', style: AppTextStyles.button),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
