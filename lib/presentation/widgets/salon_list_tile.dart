import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/models.dart';

class SalonListTile extends StatelessWidget {
  final SalonModel salon;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const SalonListTile({
    super.key,
    required this.salon,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: salon.imageUrl,
                    width: 130,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 130,
                      height: 120,
                      color: AppColors.inputFill,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 130,
                      height: 120,
                      color: AppColors.inputFill,
                      child: const Icon(Icons.store, color: AppColors.textLight),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        salon.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: salon.isFavorite ? AppColors.error : AppColors.textGrey,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if (salon.distance.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        salon.distance,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.accentDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.categories.join(' . '),
                    style: AppTextStyles.small.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salon.name,
                    style: AppTextStyles.bodySemiBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salon.address,
                    style: AppTextStyles.small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.star, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${salon.rating}',
                        style: AppTextStyles.smallBold.copyWith(color: AppColors.textDark),
                      ),
                      Text(' (${_formatCount(salon.reviewCount)})', style: AppTextStyles.small),
                      if (salon.discount > 0) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.local_offer, color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '-${salon.discount}%',
                          style: AppTextStyles.smallBold.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}
