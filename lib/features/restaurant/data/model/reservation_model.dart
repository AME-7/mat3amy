class ReservationModel {
  final String? id;
  final String? userId;
  final String? userName;
  final String? restaurantId;
  final String? restaurantName;
  final int? persons;
  final String? date;
  final String? time;
  final String? phone;
  final String? status;

  final List<Map<String, dynamic>>? meals;
  final double? totalPrice;

  ReservationModel({
    this.id,
    this.userId,
    this.userName,
    this.restaurantId,
    this.restaurantName,
    this.persons,
    this.date,
    this.time,
    this.phone,
    this.meals,
    this.totalPrice,
    this.status,
  });

  factory ReservationModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return ReservationModel(
      id: documentId,
      userId: json['userId'],
      userName: json['userName'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      persons: json['persons'],
      date: json['date'],
      time: json['time'],
      phone: json['phone'],
      meals: json['meals'] != null
          ? List<Map<String, dynamic>>.from(json['meals'])
          : [],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      status: json["status"] ?? "panding",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'persons': persons,
      'date': date,
      'time': time,
      'phone': phone,
      'meals': meals ?? [],
      'totalPrice': totalPrice ?? 0,
      'status': status ?? 'panding',
    };
  }
}
