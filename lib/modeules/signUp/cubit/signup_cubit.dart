import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:Social_App/models/user_model.dart';
import 'package:Social_App/modeules/signUp/cubit/signup_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  bool isHint = true;
  IconData icon = Icons.remove_red_eye_outlined;

  changeHintText() {
    isHint = !isHint;
    icon =
        isHint ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined;
    emit(ChangeHintTextState());
  }

  void postRegister({
    required String name,
    required String phone,
    required String email,
     String image = "https://image.flaticon.com/icons/png/512/1160/1160040.png",
     String cover = "https://image.freepik.com/free-photo/top-view-chopping-board-with-delicious-kebab-lemon_23-2148685530.jpg",
     String bio = "Write yor bio ...",
    required String password,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value){
      getUserData(email: email,password: password,phone: phone,uid: value.user!.uid,name: name,isVerified: value.user!.emailVerified,bio: bio,cover: cover,image: image);
      emit(SignUpSuccessState());
    }).catchError((error){
    emit(SignUpErrorState(error.toString()));
    print(error);
    });
  }


  void getUserData({
    required String name,
    required String phone,
    required String email,
    required String image,
    required String cover,
    required String bio,
    required bool isVerified,
    required String password,
    required String uid,

  }){
    emit(UserLoadingState());
    UserModel model = UserModel(name: name,phone: phone,email: email,isVerified: isVerified,cover: cover,bio: bio,image: image,uid: uid);
    FirebaseFirestore.instance.collection('users').doc(uid).set(model.toMap()).then((value){

      emit(UserSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(UserErrorState(e.toString()));
    });
  }
}
