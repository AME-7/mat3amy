import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/restaurant/screen/restaurant_home_screen.dart';
import 'package:mat3amy/features/restaurant/screen/restaurant_meals_screen.dart';
import 'package:mat3amy/features/restaurant/screen/restaurant_profile_screen.dart';
import 'package:mat3amy/features/restaurant/screen/restaurant_reservations_screen.dart';

class RestaurantMainAppScreen extends StatefulWidget {
  const RestaurantMainAppScreen({super.key});

  @override
  State<RestaurantMainAppScreen> createState() =>
      _RestaurantMainAppScreenState();
}

class _RestaurantMainAppScreenState extends State<RestaurantMainAppScreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = const [
      RestaurantHomeScreen(),
      RestaurantMealsScreen(),
      RestaurantReservationsScreen(),
      RestaurantProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: .2),
            ),
          ],
        ),
        child: GNav(
          curve: Curves.easeOutExpo,
          rippleColor: Colors.grey,
          hoverColor: Colors.grey,
          haptic: true,
          gap: 5,
          tabBorderRadius: 20,
          activeColor: Colors.white,
          tabBackgroundColor: AppColors.primaryColor,
          textStyle: AppTextStyles.body16.copyWith(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          selectedIndex: currentIndex,
          onTabChange: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.dashboard, text: "الرئيسية"),
            GButton(icon: Icons.restaurant_menu, text: "الوجبات"),
            GButton(icon: Icons.calendar_month, text: "الحجوزات"),
            GButton(icon: Icons.person, text: "الحساب"),
          ],
        ),
      ),
    );
  }
}
