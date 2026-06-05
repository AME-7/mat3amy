import 'package:go_router/go_router.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/features/auth/presentation/page/login_screen.dart';
import 'package:mat3amy/features/intro/enboarding/onboarding_screen.dart';
import 'package:mat3amy/features/intro/splash/splash_screen.dart';
import 'package:mat3amy/features/intro/welcom/welcome_screen.dart';

class AppRouter {
  // configuration
  static GoRouter routes = GoRouter(
    navigatorKey: globalContext,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
