import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text('Forgot password,', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Please type your email below and we will give you a OTP code',
                style: AppTextStyles.caption.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 48),
              const CustomTextField(
                hint: 'Email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Use phone number?',
                  style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Send Code',
                onPressed: () => context.push('/email-verification'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
