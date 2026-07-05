class RatingModel {
  final String? id;
  final String? userName;
  final String? userId;
  final String? restaurantId;
  final double? rate;
  final String? comment;

  RatingModel({
    this.id,
    this.userId,
    this.restaurantId,
    this.rate,
    this.comment,
    this.userName,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json, String documentId) {
    return RatingModel(
      id: documentId,
      userId: json['userId'],
      userName: json['userName'],
      restaurantId: json['restaurantId'],
      rate: (json['rate'] as num?)?.toDouble(),
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'restaurantId': restaurantId,
      'rate': rate,
      'comment': comment,
    };
  }
}
