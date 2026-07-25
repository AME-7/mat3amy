class RestaurantRequestModel {
  final String? id;
  final String ownerId;

  final String name;
  final String description;

  final String image;

  final String category;
  final String mapUrl;
  final String phone;
  final String city;
  final int tablesCount;
  final String workHours;

  final String status;

  RestaurantRequestModel({
    this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.mapUrl,
    required this.phone,
    required this.city,
    required this.tablesCount,
    required this.workHours,
    this.status = "pending",
  });

  factory RestaurantRequestModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return RestaurantRequestModel(
      id: documentId,
      ownerId: json["ownerId"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      mapUrl: json["mapUrl"] ?? "",
      phone: json["phone"] ?? "",
      city: json["city"] ?? "",
      tablesCount: json["tablesCount"] ?? 0,
      workHours: json["workHours"] ?? "",
      status: json["status"] ?? "pending",
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
      "phone": phone,
      "city": city,
      "tablesCount": tablesCount,
      "workHours": workHours,
      "status": status,
    };
  }

  Map<String, dynamic> toUpdateData() {
    return {
      "name": name,
      "description": description,
      "image": image,
      "category": category,
      "mapUrl": mapUrl,
      "phone": phone,
      "city": city,
      "tablesCount": tablesCount,
      "workHours": workHours,
      "status": status,
    };
  }
}
