class RestaurantModel {
  final String? id;

  final String? ownerId;

  final String? name;
  final String? description;
  final String? image;
  final String? category;
  final String? mapUrl;

  // الحقول القديمة
  final String? distance;
  final double? rate;

  // الحقول الجديدة
  final String? phone;
  final String? city;
  final int? tablesCount;
  final String? workHours;
  final String? status;

  RestaurantModel({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.image,
    this.category,
    this.mapUrl,
    this.distance,
    this.rate,
    this.phone,
    this.city,
    this.tablesCount,
    this.workHours,
    this.status,
  });

  factory RestaurantModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return RestaurantModel(
      id: documentId,
      ownerId: json["ownerId"],
      name: json["name"],
      description: json["description"],
      image: json["image"],
      category: json["category"],
      mapUrl: json["mapUrl"],
      distance: json["distance"],
      rate: (json["rate"] as num?)?.toDouble(),
      phone: json["phone"],
      city: json["city"],
      tablesCount: json["tablesCount"],
      workHours: json["workHours"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ownerId": ownerId,
      "name": name,
      "description": description,
      "image": image,
      "category": category,
      "mapUrl": mapUrl,

      // القديمة
      "distance": distance,
      "rate": rate,

      // الجديدة
      "phone": phone,
      "city": city,
      "tablesCount": tablesCount,
      "workHours": workHours,
      "status": status,
    };
  }
}
