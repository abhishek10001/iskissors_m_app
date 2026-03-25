import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('My Bookings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 80, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            Text('No bookings yet', style: AppTextStyles.heading3.copyWith(color: AppColors.textGrey)),
            const SizedBox(height: 8),
            Text('Your upcoming bookings will appear here', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
