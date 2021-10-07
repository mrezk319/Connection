class UserModel {
  String? name;
  String? phone;
  String? email;
  String? image;
  String? cover;
  String? bio;
  String? uid;
  bool? isVerified;
  UserModel({
    this.name,
    this.phone,
    this.email,
    this.image,
    this.cover,
    this.bio,
    this.uid,
    this.isVerified,
  });

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'uid': uid,
      'bio': bio,
      'cover': cover,
      'isVerified': isVerified,
    };
  }

  UserModel.fromJson(Map<String,dynamic>? json){
    name = json!['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    cover = json['cover'];
    uid = json['uid'];
    bio = json['bio'];
    isVerified = json['isVerified'];
  }
}