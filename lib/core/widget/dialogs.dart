import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

enum DialogType { success, error }

void showMyDialog(
  BuildContext context,
  String errorMsg, {
  DialogType type = DialogType.error,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: type == DialogType.error
          ? AppColors.errorColor
          : Colors.green,
      content: Row(
        children: [
          const Icon(Icons.error, color: AppColors.whiteColor, size: 20),
          const Gap(10),
          Text(errorMsg),
        ],
      ),
    ),
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.darkColor.withValues(alpha: 0.7),
    builder: (context) => Center(child: Lottie.asset(AppImages.loadingJson)),
  );
}
