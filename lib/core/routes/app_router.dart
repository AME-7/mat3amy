import 'package:go_router/go_router.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/featurs/enboarding/onboarding_screen.dart';
import 'package:mat3amy/featurs/splash/splash_screen.dart';

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
    ],
  );
}
