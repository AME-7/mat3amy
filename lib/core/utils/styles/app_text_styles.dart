import 'package:flutter/material.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

abstract class AppTextStyles {
  static const TextStyle headline30 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle body16 = TextStyle(fontSize: 16);
  static const TextStyle small14 = TextStyle(fontSize: 14);
  static const TextStyle caption12 = TextStyle(
    fontSize: 12,
    color: AppColors.greyColor,
  );
}
