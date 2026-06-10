class MealOrderModel {
  final String mealId;
  final String mealName;
  final int quantity;
  final double price;
  final List<String> extras;

  MealOrderModel({
    required this.mealId,
    required this.mealName,
    required this.quantity,
    required this.price,
    required this.extras,
  });

  Map<String, dynamic> toJson() {
    return {
      "mealId": mealId,
      "mealName": mealName,
      "quantity": quantity,
      "price": price,
      "extras": extras,
    };
  }
}
