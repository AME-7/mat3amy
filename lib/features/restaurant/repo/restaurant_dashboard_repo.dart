import 'package:dartz/dartz.dart';
import 'package:mat3amy/core/services/firebase/failure/failure.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/rating_model.dart';
import 'package:mat3amy/features/restaurant/model/reservation_model.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_model.dart';

class RestaurantDashboardRepo {
  static Future<Either<Failure, RestaurantModel?>> getMyRestaurant() async {
    try {
      final restaurant = await FirebaseProvider.getMyRestaurant();
      return right(restaurant);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ أثناء تحميل بيانات المطعم"));
    }
  }

  static Future<Either<Failure, List<MealModel>>> getMeals(
    String restaurantId,
  ) async {
    try {
      final meals = await FirebaseProvider.getMealsData(restaurantId);
      return right(meals);
    } catch (e) {
      return left(Failure(massage: "تعذر تحميل الوجبات"));
    }
  }

  static Future<Either<Failure, List<ReservationModel>>> getReservations(
    String restaurantId,
  ) async {
    try {
      final reservations = await FirebaseProvider.getRestaurantReservations(
        restaurantId,
      );

      return right(reservations);
    } catch (e) {
      return left(Failure(massage: "تعذر تحميل الحجوزات"));
    }
  }

  static Future<Either<Failure, Unit>> addMeal(MealModel meal) async {
    try {
      await FirebaseProvider.addMeal(meal);
      return right(unit);
    } catch (e) {
      return left(Failure(massage: "تعذر إضافة الوجبة"));
    }
  }

  static Future<Either<Failure, Unit>> updateMeal(MealModel meal) async {
    try {
      await FirebaseProvider.updateMeal(meal);
      return right(unit);
    } catch (e) {
      return left(Failure(massage: "تعذر تعديل الوجبة"));
    }
  }

  static Future<Either<Failure, Unit>> deleteMeal(String mealId) async {
    try {
      await FirebaseProvider.deleteMeal(mealId);
      return right(unit);
    } catch (e) {
      return left(Failure(massage: "تعذر حذف الوجبة"));
    }
  }

  static Future<Either<Failure, Unit>> updateRestaurant(
    RestaurantModel restaurant,
  ) async {
    try {
      await FirebaseProvider.updateRestaurant(restaurant);
      return right(unit);
    } catch (e) {
      return left(Failure(massage: "تعذر تحديث بيانات المطعم"));
    }
  }

  static Future<Either<Failure, RestaurantModel?>> getRestaurant() {
    return getMyRestaurant();
  }

  static Future<Either<Failure, List<MealModel>>> getMyMeals() async {
    try {
      final restaurant = await FirebaseProvider.getMyRestaurant();

      if (restaurant == null) {
        return right([]);
      }

      final meals = await FirebaseProvider.getMealsData(restaurant.id!);

      return right(meals);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ"));
    }
  }

  static Future<Either<Failure, List<ReservationModel>>>
  getMyReservations() async {
    try {
      final restaurant = await FirebaseProvider.getMyRestaurant();

      if (restaurant == null) {
        return right([]);
      }

      final reservations = await FirebaseProvider.getRestaurantReservations(
        restaurant.id!,
      );

      return right(reservations);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ"));
    }
  }

  static Future<Either<Failure, Unit>> updateReservationStatus({
    required String reservationId,
    required String status,
  }) async {
    try {
      await FirebaseProvider.updateReservationStatus(
        reservationId: reservationId,
        status: status,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ"));
    }
  }

  static Future<Either<Failure, List<RatingModel>>> getMyRatings() async {
    try {
      final restaurant = await FirebaseProvider.getMyRestaurant();

      if (restaurant == null) {
        return right([]);
      }

      final ratings = await FirebaseProvider.getRestaurantRatings(
        restaurant.id!,
      );

      return right(ratings);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ"));
    }
  }
}
