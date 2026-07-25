import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
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
    goNext();
  }

  Future<void> goNext() async {
    await Future.delayed(const Duration(seconds: 3));

    bool isOnboardingShown = SharedPref.isOnboardingShown();

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (isOnboardingShown) {
        pushReplacement(context, Routes.welcome);
      } else {
        pushReplacement(context, Routes.onboarding);
      }
      return;
    }

    final doc = await FirebaseProvider.usersCollection.doc(user.uid).get();

    if (!doc.exists) {
      pushReplacement(context, Routes.login);
      return;
    }

    final role = doc.data()?["role"];

    if (role == "admin") {
      pushReplacement(context, Routes.adminRequests);
    } else if (role == "restaurant") {
      final restaurant = await FirebaseProvider.getMyRestaurant();

      if (restaurant != null) {
        pushReplacement(context, Routes.restaurantMain);
      } else {
        pushReplacement(context, Routes.restaurantInfo);
      }
    } else {
      pushReplacement(context, Routes.mainApp);
    }
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
