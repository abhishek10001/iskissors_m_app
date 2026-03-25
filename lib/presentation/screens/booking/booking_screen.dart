import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/mock_data.dart';
import '../../../providers/providers.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String salonId;
  const BookingScreen({super.key, required this.salonId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _selectedSpecialistIndex = 0;
  int _selectedDateIndex = 2;
  int _selectedTimeIndex = -1;
  final _notesController = TextEditingController();

  final _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  final _times = ['09:00', '10:00', '10:30', '12:00', '14:30', '15:00', '16:00'];
  final _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices = ref.watch(selectedServicesProvider);
    final totalPrice = selectedServices.fold<double>(0, (sum, s) => sum + s.price);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text('Book Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected services summary
            Text('Selected Service', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            ...selectedServices.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: s.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: AppTextStyles.captionMedium.copyWith(color: AppColors.textDark)),
                        Text(s.duration, style: AppTextStyles.small),
                      ],
                    ),
                  ),
                  Text('\$${s.price.toInt()}', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14, color: AppColors.primary)),
                ],
              ),
            )),
            const Divider(height: 24),

            // Specialist
            Text('Choose your specialist', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.specialists.length,
                itemBuilder: (_, i) {
                  final sp = MockData.specialists[i];
                  final selected = i == _selectedSpecialistIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSpecialistIndex = i),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: selected ? AppColors.primary : Colors.transparent, width: 2),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(radius: 28, backgroundImage: CachedNetworkImageProvider(sp.imageUrl)),
                          ),
                          const SizedBox(height: 4),
                          Text(sp.name, style: AppTextStyles.small.copyWith(
                            color: selected ? AppColors.primary : AppColors.textDark,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 24),

            // Date
            Text('Select date', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (_, i) {
                  final d = _dates[i];
                  final selected = i == _selectedDateIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDateIndex = i),
                    child: Container(
                      width: 56,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.transparent,
                        border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_dayNames[d.weekday - 1], style: AppTextStyles.small.copyWith(color: selected ? AppColors.white : AppColors.textGrey)),
                          const SizedBox(height: 4),
                          Text('${d.day}', style: AppTextStyles.heading3.copyWith(color: selected ? AppColors.white : AppColors.textDark)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Time
            Text('Select time', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _times.asMap().entries.map((e) {
                final selected = e.key == _selectedTimeIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTimeIndex = e.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(e.value, style: AppTextStyles.captionMedium.copyWith(
                      color: selected ? AppColors.white : AppColors.textDark,
                    )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Notes
            Text('Notes', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type your notes here..',
                hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.inputFill,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: AppTextStyles.body.copyWith(fontSize: 14),
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
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total', style: AppTextStyles.caption),
                  Text('\$${totalPrice.toInt()}', style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _selectedTimeIndex >= 0 ? () => context.push('/checkout') : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    minimumSize: const Size(0, 48),
                    disabledBackgroundColor: AppColors.textLight,
                  ),
                  child: Text('Checkout', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
