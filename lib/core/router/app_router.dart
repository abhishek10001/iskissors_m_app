import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/email_verification_screen.dart';
import '../../presentation/screens/auth/reset_password_screen.dart';
import '../../presentation/screens/home/main_shell_screen.dart';
import '../../presentation/screens/home/search_screen.dart';
import '../../presentation/screens/shop/shop_details_screen.dart';
import '../../presentation/screens/shop/service_list_screen.dart';
import '../../presentation/screens/booking/booking_screen.dart';
import '../../presentation/screens/booking/checkout_screen.dart';
import '../../presentation/screens/messages/chat_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/email-verification',
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainShellScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/shop/:id',
      builder: (context, state) => ShopDetailsScreen(
        salonId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/services/:salonId',
      builder: (context, state) => ServiceListScreen(
        salonId: state.pathParameters['salonId']!,
      ),
    ),
    GoRoute(
      path: '/booking/:salonId',
      builder: (context, state) => BookingScreen(
        salonId: state.pathParameters['salonId']!,
      ),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/chat/:salonId',
      builder: (context, state) => ChatScreen(
        salonId: state.pathParameters['salonId']!,
        salonName: state.uri.queryParameters['name'] ?? 'Salon',
        salonImage: state.uri.queryParameters['image'] ?? '',
      ),
    ),
  ],
);
