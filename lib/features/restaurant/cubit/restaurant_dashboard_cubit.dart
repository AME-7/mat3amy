import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/features/main/home/presentation/model/meal_model.dart';
import 'package:mat3amy/features/restaurant/data/model/reservation_model.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_state.dart';
import 'package:mat3amy/features/restaurant/data/model/restaurant_model.dart';
import 'package:mat3amy/features/restaurant/data/repo/restaurant_dashboard_repo.dart';

class RestaurantDashboardCubit extends Cubit<RestaurantDashboardState> {
  RestaurantDashboardCubit() : super(RestaurantDashboardInitialState());

  RestaurantModel? restaurant;

  List<MealModel> meals = [];

  List<ReservationModel> reservations = [];

  Future<void> loadDashboard() async {
    emit(RestaurantDashboardLoadingState());

    final restaurantResult = await RestaurantDashboardRepo.getMyRestaurant();

    await restaurantResult.fold(
      (failure) async {
        emit(RestaurantDashboardErrorState(error: failure.massage));
      },
      (restaurantData) async {
        restaurant = restaurantData;

        if (restaurant == null) {
          emit(
            RestaurantDashboardErrorState(error: "لم يتم العثور على المطعم"),
          );
          return;
        }

        final mealsResult = await RestaurantDashboardRepo.getMeals(
          restaurant!.id!,
        );

        mealsResult.fold((_) {}, (data) => meals = data);

        final reservationsResult =
            await RestaurantDashboardRepo.getReservations(restaurant!.id!);

        reservationsResult.fold((_) {}, (data) => reservations = data);

        emit(
          RestaurantDashboardSuccessState(
            restaurant: restaurant,
            meals: meals,
            reservations: reservations,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  Future<void> deleteMeal(String mealId) async {
    final result = await RestaurantDashboardRepo.deleteMeal(mealId);

    result.fold(
      (failure) {
        emit(RestaurantDashboardErrorState(error: failure.massage));
      },
      (_) async {
        await loadDashboard();
      },
    );
  }

  Future<void> addMeal(MealModel meal) async {
    final result = await RestaurantDashboardRepo.addMeal(meal);

    result.fold(
      (failure) {
        emit(RestaurantDashboardErrorState(error: failure.massage));
      },
      (_) async {
        await loadDashboard();
      },
    );
  }

  Future<void> updateMeal(MealModel meal) async {
    final result = await RestaurantDashboardRepo.updateMeal(meal);

    result.fold(
      (failure) {
        emit(RestaurantDashboardErrorState(error: failure.massage));
      },
      (_) async {
        await loadDashboard();
      },
    );
  }

  Future<void> updateReservationStatus({
    required String reservationId,
    required String status,
  }) async {
    final result = await RestaurantDashboardRepo.updateReservationStatus(
      reservationId: reservationId,
      status: status,
    );

    result.fold(
      (failure) {
        emit(RestaurantDashboardErrorState(error: failure.massage));
      },
      (_) async {
        await loadDashboard();
      },
    );
  }

  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    final result = await RestaurantDashboardRepo.updateRestaurant(restaurant);

    result.fold(
      (failure) {
        emit(RestaurantDashboardErrorState(error: failure.massage));
      },
      (_) async {
        await loadDashboard();
      },
    );
  }
}
