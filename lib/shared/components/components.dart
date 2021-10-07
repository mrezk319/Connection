import 'package:flutter/material.dart';
import 'package:social_app_2/modeules/signUp/cubit/signup_cubit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
Widget textFormField(
    {required TextEditingController controller, required String hintText,IconData? suffixIcon,bool? isHint, func,TextInputType? keyBoard,TextEditingController? pass,TextEditingController? confirmpass,IconData? prefixIcon}) => TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(icon: Icon(suffixIcon),onPressed: func,),
        prefixIcon: Icon(prefixIcon),
      ),
      keyboardType: keyBoard,
      obscureText: isHint??false,
  validator: (val){
       if(val!.isEmpty){
         return "This Field can not be empty!";
       }
       if(confirmpass != null)
       if(confirmpass.text != pass!.text){
         return "The password is not the same";
       }
    },
    );

ToastFuture toast(Color color,String msg,context) => showToast(msg,context: context,backgroundColor: color,animDuration: Duration(milliseconds: 250));