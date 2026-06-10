import 'package:flutter/material.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/services/local/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    bool isOnboardingShown = SharedPref.isOnboardingShown();
    bool isLoggedIn = SharedPref.getUserId().isNotEmpty == true;
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (isLoggedIn) {
        pushReplacement(context, Routes.welcome);
      } else {
        if (isOnboardingShown) {
          pushReplacement(context, Routes.welcome);
        } else {
          pushReplacement(context, Routes.onboarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppImages.bg,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
