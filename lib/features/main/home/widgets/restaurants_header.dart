import 'package:flutter/material.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';

class RestaurantsHeader extends StatelessWidget {
  const RestaurantsHeader({super.key, required this.restaurants});

  final List<RestaurantModel> restaurants;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("أفضل المطاعم", style: AppTextStyles.title18),
        Text(
          "${restaurants.length} مطعم",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
