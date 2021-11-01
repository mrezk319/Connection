import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Social_App/layout/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Social_App/models/message_model.dart';
import 'package:Social_App/models/post_model.dart';
import 'package:Social_App/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Social_App/modeules/chat/chats.dart';
import 'package:Social_App/modeules/home/home_screen.dart';
import 'package:Social_App/modeules/settings/settings_screen.dart';
import 'package:Social_App/modeules/signUp/cubit/signup_states.dart';
import 'package:Social_App/modeules/users/users_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData({required uid}) {
    emit(getUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(getUserSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(getUserErrorState(e.toString()));
    });
  }

  late int currentIndex = 0;

  List<String> titles = ["News Feed", "Chats", "Users", "Settings"];
  List<Widget> screens = [
    Home(),
    Chats(),
    Users(),
    Setings(),
  ];

  void changeIndex(index)  {
    currentIndex = index;
    emit(changeIndexState());
  }

  File? profileImage;
  final picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(getProfileImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(getProfileImagePickerErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(getCoverImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(getCoverImagePickerErrorState());
    }
  }

  void uploadprofile({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(uploadProfileImagePickerLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('usersImages/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      print(value.ref.getDownloadURL());
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, image: value);
        emit(uploadProfileImagePickerSuccessState());
      }).catchError((e) {
        emit(uploadCoverImagePickerErrorState());
      });
    }).catchError((e) {
      emit(uploadProfileImagePickerErrorState());
    });
  }

  void uploadCover({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(uploadCoverImagePickerLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('usersImages/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      print(value.ref.getDownloadURL());
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, cover: value);
        emit(uploadCoverImagePickerSuccessState());
      }).catchError((e) {
        emit(uploadCoverImagePickerErrorState());
      });
    }).catchError((e) {
      emit(uploadCoverImagePickerErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    cover,
    image,
    email,
    uid,
    isVerified,
  }) {
    emit(uploadUserLoadingState());
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      email: email ?? userModel!.email,
      uid: uid ?? userModel!.uid,
      isVerified: isVerified ?? userModel!.isVerified,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value) {
      emit(updateUploadDataUser());
      getUserData(uid: userModel!.uid);
    }).catchError((e) {
      print(e.toString());
      emit(uploadUserErrorState());
    });
  }

  File? postImage;

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(getCoverImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(getCoverImagePickerErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(addPhotoPost());
  }

  void uploadPostImage({
    String? postText,
    String? date,
  }) {
    emit(uploadPostImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('postsImages/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadPost(date: date, postText: postText, postimage: value.toString());
        emit(uploadPostImageSuccessState());
      }).catchError((e) {
        emit(uploadPostImageErrorState());
      });
    }).whenComplete((){
      postImage = null;
    }).catchError((error) {
      print(error.toString());
      emit(uploadPostImageErrorState());
    });
  }

  PostModel? postModel;

  void uploadPost({
    required String? date,
    String? postText,
    String postimage = "",
  }) {
    emit(postUploadLoadingState());
    postModel = PostModel(
        name: userModel!.name,
        image: userModel!.image,
        email: userModel!.email,
        date: date,
        postText: postText,
        postImage: postimage,
        uid: userModel!.uid);
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toMap())
        .then((value) {
      print(value.id);
      emit(postUploadSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(postUploadErrorState());
    });
  }

  late List<PostModel> posts;
  late List<String> postsId;
  late List<int> Likes;
  late List<bool> isLikes;

  Future? getAllPosts() async {
    emit(getPostsLoadingState());
    isLikes = [];
    posts = [];
    postsId = [];
    Likes = [];
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      isLikes = [];
      Likes = [];
      posts = [];
      postsId = [];
      for (var element in value.docs) {
        element.reference.collection('Likes').get().then((value) {
          posts.add(PostModel.fromJson(element.data()));
          Likes.add(value.docs.length);
          postsId.add(element.id);
        }).whenComplete(() async{
         await FirebaseFirestore.instance
                .collection('posts')
                .doc(postsId[postsId.length-1])
                .collection('Likes')
                .doc(userModel!.uid)
                .get()
                .then((value) {
                  print(postsId.length-1);
                  isLikes.add(value.exists);
            });
          emit(testes());
          emit(getPostsSuccessState());
          print(isLikes.length);
          print(Likes.length);
        });
        emit(getSuccess());
      };
    }).catchError((error) {
      emit(getPostsErrorState());
    });
  }

  late List<PostModel> myposts;
  late List<String> mypostsId;
  late List<int> myLikes;
  late List<bool> myisLikes;
  Future? getMyPosts() async {
    emit(getMyPostsLoadingState());
    myisLikes = [];
    myposts = [];
    mypostsId = [];
    myLikes = [];
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      myisLikes = [];
      myLikes = [];
      myposts = [];
      mypostsId = [];
      for (var element in value.docs) {
          element.reference.collection('Likes').get().then((value) {
            myposts.add(PostModel.fromJson(element.data()));
            myLikes.add(value.docs.length);
            mypostsId.add(element.id);
          }).whenComplete(() async {
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(mypostsId[mypostsId.length - 1])
                .collection('Likes')
                .doc(userModel!.uid)
                .get()
                .then((value) {
              print(mypostsId.length - 1);
              myisLikes.add(value.exists);
            });
            emit(testes());
            emit(getPostsSuccessState());
          });
          emit(getMySuccess());
      };
    }).catchError((error) {
      emit(getMyPostsErrorState());
    });
  }
  void increaseNum(index) {
    Likes[index]++;
    if(Likes[index] > 1)

    emit(increaseNumState());
  }
  void increaseMyNum(index) {
    myLikes[index]++;
    if(Likes[index] > 1)

      emit(increaseNumState());
  }

  void decreaseNum(index) {
    Likes[index]--;

    emit(decreaseNumState());
  }
  void decreaseMyNum(index) {
    myLikes[index]--;

    emit(decreaseNumState());
  }

  void likePost(String postid, index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('Likes')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      increaseNum(index);
      emit(likePostSuccessState());
    }).catchError((error) {
      emit(likePostErrorState());
    });
  }

  void likeMyPost(String postid, index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('Likes')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      increaseMyNum(index);
      emit(likePostSuccessState());
    }).catchError((error) {
      emit(likePostErrorState());
    });
  }
  void disLike(String postid, index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('Likes')
        .doc(userModel!.uid)
        .delete()
        .whenComplete(() {
      decreaseNum(index);
      print("DisLikeComplete");
      emit(dislikePostSuccessState());
    });
  }
  void disMyLike(String postid, index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('Likes')
        .doc(userModel!.uid)
        .delete()
        .whenComplete(() {
      decreaseMyNum(index);
      print("DisLikeComplete");
      emit(dislikePostSuccessState());
    });
  }

  void deletePost() {}

  late List<UserModel> users;

  Future? getAllUsers() {
    emit(getAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        element.reference.get().then((value) {
          if(userModel!.uid != element.data()['uid'])
          users.add(UserModel.fromJson(element.data()));
          print(value.data());
        }).whenComplete(() {
          emit(getAllUsersSuccessState());
        });
      }
      ;
    }).catchError((error) {
      emit(getAllUsersErrorState());
    });
  }

  MessageModel? messageModel;
  void sendMessage({
  required String text,
  required String recieverId,
  required String date,
}){
    messageModel = MessageModel(date: date,text: text,recieverId: recieverId,senderId: userModel!.uid);
    FirebaseFirestore.instance.collection('users').doc(userModel!.uid).collection('chats').doc(recieverId).collection('messages').add(messageModel!.toMap()).then((value){
      emit(sendMessageSuccessState());
    }).catchError((error){
      emit(sendMessageErrorState());
    });

    FirebaseFirestore.instance.collection('users').doc(recieverId).collection('chats').doc(userModel!.uid).collection('messages').add(messageModel!.toMap()).then((value){
      emit(sendMessagetoRecieverSuccessState());
    }).catchError((error){
      emit(sendMessagetoRecieverErrorState());
    });
  }

  List<MessageModel>? messagesList;
   getMessages({
 required String receiverId
}){
    FirebaseFirestore.instance.collection('users').doc(userModel!.uid).collection('chats').doc(receiverId).collection('messages').orderBy('date').snapshots().listen((event) {
      messagesList = [];
      event.docs.forEach((e){
        messagesList!.add(MessageModel.fromJson(e.data()));
        print(e.data());
      });

      emit(getMessagesSuccessState());
    });
  }
}
