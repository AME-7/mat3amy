import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/features/admin/screens/restaurant_requests_screen.dart';
import 'package:mat3amy/features/auth/presentation/page/login_screen.dart';
import 'package:mat3amy/features/auth/presentation/page/register_screen.dart';
import 'package:mat3amy/features/intro/enboarding/onboarding_screen.dart';
import 'package:mat3amy/features/intro/splash/splash_screen.dart';
import 'package:mat3amy/features/intro/welcom/welcome_screen.dart';
import 'package:mat3amy/features/main/page/main_app_screen.dart';
import 'package:mat3amy/features/main/profile/setting/settings_view.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_cubit.dart';
import 'package:mat3amy/features/restaurant/peresatation/screen/restaurant_info_screen.dart';
import 'package:mat3amy/features/restaurant/peresatation/screen/restaurant_main_app_screen.dart';

class AppRouter {
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
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.mainApp,
        builder: (context, state) => const MainAppScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.restaurantInfo,
        builder: (context, state) => BlocProvider(
          create: (_) => RestaurantCubit(),
          child: const RestaurantInfoScreen(),
        ),
      ),
      GoRoute(
        path: Routes.restaurantMain,
        builder: (context, state) => BlocProvider(
          create: (_) => RestaurantDashboardCubit()..loadDashboard(),
          child: const RestaurantMainAppScreen(),
        ),
      ),
      GoRoute(
        path: Routes.adminRequests,
        builder: (context, state) => BlocProvider(
          create: (_) => RestaurantCubit()..getRestaurantRequests(),
          child: const AdminRequestsScreen(),
        ),
      ),
    ],
  );
}
