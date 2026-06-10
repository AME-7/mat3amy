class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;

  UserModel({this.uid, this.name, this.email, this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email, 'image': image};
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (image != null) {
      data['image'] = image;
    }

    return data;
  }
}
