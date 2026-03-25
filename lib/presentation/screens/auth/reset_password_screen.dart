import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNew = true;
  bool _obscureConfirm = true;

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
              Text('New password,', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Now, you can create new password and confirm it\nbelow',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // New password – underline style
              CustomTextField(
                hint: 'New password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureNew,
                isUnderline: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm password – underline style
              CustomTextField(
                hint: 'Confirm new password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirm,
                isUnderline: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),

              const Spacer(),
              PrimaryButton(
                text: 'Confirm New Password',
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
