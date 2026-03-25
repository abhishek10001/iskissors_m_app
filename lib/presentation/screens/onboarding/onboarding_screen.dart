import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      title: 'Best Stylist For You',
      subtitle: 'Styling your appearance\naccording to your lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
    ),
    _OnboardingData(
      title: 'Meet Our Specialists',
      subtitle:
          'There are many best stylists from\nall the best salons ever',
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800',
    ),
    _OnboardingData(
      title: 'Find The Best Service',
      subtitle:
          'There are various services from the best\nsalons that have become our partners.',
      imageUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToJoinScreen();
    }
  }

  void _goToJoinScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _JoinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // Page View – full bleed background images
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                children: [
                  // Full-bleed background image
                  Positioned.fill(
                    child: Image.network(
                      page.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.inputFill,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gradient – design shows image visible quite far down
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.6),
                            Colors.white.withValues(alpha: 0.92),
                            Colors.white,
                          ],
                          stops: const [0.0, 0.38, 0.55, 0.68, 0.78],
                        ),
                      ),
                    ),
                  ),
                  // Text content – positioned to sit just above the indicator
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 200 + bottomPadding,
                    child: Column(
                      children: [
                        Text(
                          page.title,
                          style: AppTextStyles.heading1.copyWith(
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.textGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Page indicator + buttons pinned at bottom
          Positioned(
            left: 24,
            right: 24,
            bottom: 32 + bottomPadding,
            child: Column(
              children: [
                // Page dots
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.accent,
                    dotColor: AppColors.textLight,
                    expansionFactor: 3,
                    spacing: 6,
                  ),
                ),
                const SizedBox(height: 32),
                // Next / Get Started button
                PrimaryButton(
                  text: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: _onNext,
                ),
                const SizedBox(height: 20),
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
                        style: AppTextStyles.link,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

// ── Onboarding Page 4: "Let's Join with Us" ─────────────────────────────────

class _JoinScreen extends StatelessWidget {
  const _JoinScreen();

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // Full-bleed background image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.inputFill,
              ),
            ),
          ),
          // Gradient overlay – design shows image extends pretty far down
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.5),
                    Colors.white.withValues(alpha: 0.85),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.35, 0.52, 0.65, 0.75],
                ),
              ),
            ),
          ),
          // Content at bottom
          Positioned(
            left: 24,
            right: 24,
            bottom: 32 + bottomPadding,
            child: Column(
              children: [
                // Title
                Text(
                  "Let's Join with Us",
                  style: AppTextStyles.heading1.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Find and book Beauty, Salon, Barber\nand Spa services anywhere, anytime',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Join with Google – white fill, subtle border
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => context.go('/main'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      side: const BorderSide(color: AppColors.divider),
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
                const SizedBox(height: 16),

                // Join with Email – purple filled
                PrimaryButton(
                  text: 'Join with Email',
                  icon: Icons.email_outlined,
                  onPressed: () => context.go('/signup'),
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
                      child: Text('Sign In', style: AppTextStyles.link),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
