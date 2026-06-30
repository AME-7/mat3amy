import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.currentUser});

  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'مرحبا، ', style: AppTextStyles.body16),
              TextSpan(
                text: currentUser?.displayName ?? '',
                style: AppTextStyles.title18.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),

        const Gap(20),

        Text(
          "احجز الآن افضل المطاعم باسرع طريقه.",
          style: AppTextStyles.title18.copyWith(
            color: AppColors.darkColor,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
