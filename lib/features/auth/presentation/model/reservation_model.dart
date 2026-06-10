import 'package:mat3amy/features/auth/presentation/model/meal_order_model.dart';

class ReservationModel {
  final String userId;
  final String restaurantId;
  final DateTime date;
  final int persons;
  final String seatingType;
  final String status;
  final double totalPrice;
  final List<MealOrderModel> orders;

  ReservationModel({
    required this.userId,
    required this.restaurantId,
    required this.date,
    required this.persons,
    required this.seatingType,
    required this.status,
    required this.totalPrice,
    required this.orders,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "restaurantId": restaurantId,
      "date": date,
      "persons": persons,
      "seatingType": seatingType,
      "status": status,
      "totalPrice": totalPrice,
      "orders": orders.map((e) => e.toJson()).toList(),
    };
  }
}
