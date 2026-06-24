import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/page/favorites_scrren.dart';
import 'package:mat3amy/features/main/home/page/home_screen.dart';
import 'package:mat3amy/features/main/home/page/my_reservation_screen.dart';
import 'package:mat3amy/features/main/profile/page/profile_screen.dart';
import 'package:mat3amy/features/main/search/search_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    HomeScreen(
      onSearch: () {
        setState(() {
          _selectedIndex = 1;
        });
      },
    ),
    const SearchScreen(),
    const MyReservationsScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
          tabBorderRadius: 20,
          gap: 5,
          activeColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.primaryColor,
          textStyle: AppTextStyles.body16.copyWith(color: AppColors.whiteColor),
          tabs: const [
            GButton(iconSize: 28, icon: Icons.home, text: 'الرئيسية'),
            GButton(icon: Icons.search, text: 'البحث'),
            GButton(
              iconSize: 28,
              icon: Icons.calendar_month_rounded,
              text: 'الحجوزات',
            ),
            GButton(iconSize: 29, icon: Icons.favorite, text: 'المفضلة'),
            GButton(iconSize: 29, icon: Icons.person, text: 'الحساب'),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}
