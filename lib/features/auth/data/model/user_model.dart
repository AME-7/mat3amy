class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? image;
  final String? phone;
  final String? city;
  final String? bio;
  final String? role;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.city,
    this.bio,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'],
      city: json['city'],
      bio: json['bio'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'phone': phone,
      'city': city,
      'bio': bio,
      'role': role,
    };
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (image != null) data['image'] = image;
    if (phone != null) data['phone'] = phone;
    if (city != null) data['city'] = city;
    if (bio != null) data['bio'] = bio;
    if (role != null) data['role'] = role;

    return data;
  }
}
