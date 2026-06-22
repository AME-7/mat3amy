class MealModel {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final double? rate;
  final double? price;
  final String? restaurantId;

  MealModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.rate,
    this.price,
    this.restaurantId,
  });

  factory MealModel.fromJson(Map<String, dynamic> json, String documentId) {
    return MealModel(
      id: documentId,
      name: json['name'],
      description: json['description'],
      image: json['image'],
      restaurantId: json['restaurantId'],
      rate: (json['rate'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'restaurantId': restaurantId,
      'rate': rate,
      'price': price,
    };
  }
}
