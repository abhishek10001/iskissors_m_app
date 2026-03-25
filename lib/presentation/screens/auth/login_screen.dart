import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    ref.read(authStateProvider.notifier).mockLogin();
    context.go('/main');
  }

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
              Text('Welcome back,', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Glad to meet you again!, please login to use the app.',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 60),

              // Email – outlined pill style with purple border
              CustomTextField(
                hint: 'Email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password – grey filled background style
              Container(
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 12),
                      child: Icon(
                        Icons.lock_outline,
                        color: AppColors.textLight,
                        size: 22,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push('/forgot-password'),
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.captionMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Sign In button
              PrimaryButton(text: 'Sign In', onPressed: _login),
              const SizedBox(height: 24),

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
              const SizedBox(height: 24),

              // Google Sign In – outlined purple border
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _login,
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
                        'Sign In with Google',
                        style: AppTextStyles.bodySemiBold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Join Now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: Text(
                      'Join Now',
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
