import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.bg,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          PositionedDirectional(
            top: 100,
            start: 25,
            end: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اهلا بيك',
                  style: AppTextStyles.headline30.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 36,
                  ),
                ),
                const Gap(15),
                Text(
                  'احجز مطعمك المفضل باسهل واسرع طريقه',
                  style: AppTextStyles.body16.copyWith(
                    color: AppColors.borderColor,
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 80,
            start: 25,
            end: 25,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .3),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'سجل الان',
                    style: AppTextStyles.title18.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildUserButton(
                    title: 'تسجيل الدخول ',
                    onTap: () {
                      pushTo(context, Routes.login);
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildUserButton(
                    title: 'انشاء حساب جديد',
                    onTap: () {
                      pushTo(context, Routes.register);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildUserButton({
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.accentColor.withValues(alpha: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.title18.copyWith(color: AppColors.darkColor),
          ),
        ),
      ),
    );
  }
}
