class PatientModel {
  final String? uid;
  final String? name;
  final String? age;
  final String? gender;
  final String? image;
  final String? email;
  final String? phone;
  final String? city;
  final String? bio;

  PatientModel({
    this.name,
    this.email,
    this.uid,
    this.image,
    this.age,
    this.gender,
    this.phone,
    this.city,
    this.bio,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      name: json['name'],
      email: json['email'],
      uid: json['uid'],
      image: json['image'],
      age: json['age'],
      gender: json['gender'],
      phone: json['phone'],
      city: json['city'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'image': image,
      'age': age,
      'gender': gender,
      'phone': phone,
      'city': city,
      'bio': bio,
    };
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (image != null) data['image'] = image;
    if (age != null) data['age'] = age;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (bio != null) data['bio'] = bio;
    if (city != null) data['city'] = city;
    if (gender != null) data['gender'] = gender;
    return data;
  }
}
