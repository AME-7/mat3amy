class RestaurantModel {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final String? category;
  final String? distance;
  final double? rate;

  RestaurantModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.category,
    this.distance,
    this.rate,
  });

  factory RestaurantModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return RestaurantModel(
      id: documentId,
      name: json['name'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
      distance: json['distance'],
      rate: (json['rate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'distance': distance,
      'rate': rate,
    };
  }
}
