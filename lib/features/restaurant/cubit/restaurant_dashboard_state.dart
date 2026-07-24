import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/reservation_model.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_model.dart';

abstract class RestaurantDashboardState {}

class RestaurantDashboardInitialState extends RestaurantDashboardState {}

class RestaurantDashboardLoadingState extends RestaurantDashboardState {}

class RestaurantDashboardSuccessState extends RestaurantDashboardState {
  final RestaurantModel? restaurant;
  final List<MealModel> meals;
  final List<ReservationModel> reservations;

  RestaurantDashboardSuccessState({
    required this.restaurant,
    required this.meals,
    required this.reservations,
  });
}

class RestaurantDashboardErrorState extends RestaurantDashboardState {
  final String error;

  RestaurantDashboardErrorState({required this.error});
}
