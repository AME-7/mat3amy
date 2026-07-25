import 'package:dartz/dartz.dart';
import 'package:mat3amy/core/services/firebase/failure/failure.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/features/restaurant/data/model/restaurant_request_model.dart';

class RestaurantRepo {
  static Future<Either<Failure, Unit>> addRestaurantRequest(
    RestaurantRequestModel request,
  ) async {
    try {
      await FirebaseProvider.addRestaurantRequest(request);

      return right(unit);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ أثناء إرسال طلب المطعم"));
    }
  }

  static Future<Either<Failure, List<RestaurantRequestModel>>>
  getRestaurantRequests() async {
    try {
      final requests = await FirebaseProvider.getRestaurantRequests();

      return right(requests);
    } catch (e) {
      return left(Failure(massage: "حدث خطأ أثناء تحميل الطلبات"));
    }
  }

  static Future<Either<Failure, Unit>> approveRestaurant(
    RestaurantRequestModel request,
  ) async {
    try {
      await FirebaseProvider.approveRestaurant(request);
      return right(unit);
    } catch (e) {
      return left(Failure(massage: "فشل قبول الطلب"));
    }
  }

  static Future<Either<Failure, Unit>> rejectRestaurant(String ownerId) async {
    try {
      await FirebaseProvider.rejectRestaurant(ownerId);
      return right(unit);
    } catch (e) {
      return left(Failure(massage: "فشل رفض الطلب"));
    }
  }
}
