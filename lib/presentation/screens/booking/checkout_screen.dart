import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedServices = ref.watch(selectedServicesProvider);
    final totalPrice = selectedServices.fold<double>(0, (sum, s) => sum + s.price);
    final totalOriginal = selectedServices.fold<double>(0, (sum, s) => sum + s.originalPrice);
    final totalDiscount = totalOriginal - totalPrice;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Receipt card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text('Booking Summary', style: AppTextStyles.heading3)),
                  const SizedBox(height: 20),

                  // Date & Time
                  _InfoRow(label: 'Date', value: 'March 12, 2021'),
                  _InfoRow(label: 'Time', value: '10:30 AM'),
                  _InfoRow(label: 'Specialist', value: 'Ronald'),
                  _InfoRow(label: 'Duration', value: _totalDuration(selectedServices)),
                  const Divider(height: 24),

                  // Services
                  Text('Services', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                  const SizedBox(height: 12),
                  ...selectedServices.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(s.name, style: AppTextStyles.caption.copyWith(color: AppColors.textDark))),
                        Text('\$${s.price.toInt()}', style: AppTextStyles.captionMedium.copyWith(color: AppColors.textDark)),
                      ],
                    ),
                  )),
                  const Divider(height: 24),

                  // Totals
                  _TotalRow(label: 'Sub Total', value: '\$${totalOriginal.toInt()}'),
                  if (totalDiscount > 0)
                    _TotalRow(label: 'Discount', value: '-\$${totalDiscount.toInt()}', valueColor: AppColors.success),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.subtitle),
                      Text('\$${totalPrice.toInt()}', style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment method
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method', style: AppTextStyles.subtitle),
                      Text('Change', style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 48, height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F71),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(child: Text('VISA', style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Visa Classic', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                          Text('****  ****  ****  2456', style: AppTextStyles.caption),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
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
              onPressed: () => _showSuccessDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: Text('Pay Now  \$${totalPrice.toInt()}', style: AppTextStyles.button),
            ),
          ),
        ),
      ),
    );
  }

  String _totalDuration(List services) {
    double hours = 0;
    for (final s in services) {
      final d = s.duration.toString();
      if (d.contains('hour')) {
        hours += double.tryParse(d.split(' ')[0]) ?? 1;
      } else if (d.contains('min')) {
        hours += (double.tryParse(d.split(' ')[0]) ?? 30) / 60;
      }
    }
    if (hours >= 1) return '${hours.toStringAsFixed(1)} hours';
    return '${(hours * 60).toInt()} min';
  }

  void _showSuccessDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 24),
              Text('Payment Success!', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text('Your appointment has been booked', style: AppTextStyles.caption, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(selectedServicesProvider.notifier).clear();
                    Navigator.of(ctx).pop();
                    context.go('/main');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text('Back to Home', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.captionMedium.copyWith(color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _TotalRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.captionMedium.copyWith(color: valueColor ?? AppColors.textDark)),
        ],
      ),
    );
  }
}
