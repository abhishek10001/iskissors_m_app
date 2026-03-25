import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text('Create an account,', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Please type full information bellow and we can\ncreate your account',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Name field – underline style
              const CustomTextField(
                hint: 'Name',
                prefixIcon: Icons.person_outline,
                isUnderline: true,
              ),
              const SizedBox(height: 8),

              // Email field – underline style
              const CustomTextField(
                hint: 'Email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isUnderline: true,
              ),
              const SizedBox(height: 8),

              // Phone field – underline style with country code
              CustomTextField(
                hint: 'Mobile number',
                keyboardType: TextInputType.phone,
                isUnderline: true,
                prefixIcon: null,
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // US flag emoji
                    const Text('🇺🇸', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '+01',
                      style: AppTextStyles.body.copyWith(fontSize: 14),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 22,
                      color: AppColors.divider,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Password field – underline style
              CustomTextField(
                hint: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                isUnderline: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 16),

              // Terms text
              RichText(
                text: TextSpan(
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textDark,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'By signing up you agree to our '),
                    TextSpan(
                      text: 'Term of use and privacy',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '\nnotice'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Join Now button
              PrimaryButton(
                text: 'Join Now',
                onPressed: () => context.push('/email-verification'),
              ),
              const SizedBox(height: 20),

              // "or" divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or', style: AppTextStyles.caption),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: 20),

              // Google button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => context.go('/main'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFF4285F4),
                                Color(0xFF34A853),
                                Color(0xFFFBBC05),
                                Color(0xFFEA4335),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0, 0, 20, 24),
                            ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Join with Google',
                        style: AppTextStyles.bodySemiBold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.captionMedium.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
