import 'package:flutter/material.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';
import 'package:mat3amy/features/main/home/widgets/restaurant_card.dart';

class RestaurantsListWidget extends StatelessWidget {
  const RestaurantsListWidget({super.key, required this.restaurants});

  final List<RestaurantModel> restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return RestaurantCardWidget(restaurant: restaurants[index]);
      },
    );
  }
}
