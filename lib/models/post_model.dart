class PostModel {
  String? name;
  String? image;
  String? uid;
  String? postImage = "";
  String? postText = "";
  String? date;
  String? email;
  PostModel({
    this.name,
    this.email,
    this.postText,
    this.postImage,
    this.image,
    this.uid,
    this.date,
  });

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'postText': postText,
      'postImage': postImage,
      'image': image,
      'uid': uid,
      'date': date,
    };
  }

  PostModel.fromJson(Map<String,dynamic>? json){
    name = json!['name'];
    email = json['email'];
    postText = json['postText'];
    postImage = json['postImage'];
    image = json['image'];
    uid = json['uid'];
    date = json['date'];
  }
}