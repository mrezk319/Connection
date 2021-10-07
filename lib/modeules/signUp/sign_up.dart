import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_2/layout/home_layout.dart';
import 'package:social_app_2/modeules/logIn/log_in.dart';
import 'package:social_app_2/modeules/signUp/cubit/signup_cubit.dart';
import 'package:social_app_2/modeules/signUp/cubit/signup_states.dart';
import 'package:social_app_2/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:social_app_2/shared/network/local.dart';
class SignUp extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>SignUpCubit(),
      child: BlocConsumer<SignUpCubit,SignUpStates>(
        builder: (context,state)=>
            Scaffold(
          body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              // ignore: prefer_const_constructors
                gradient: LinearGradient(colors: [Colors.white,Colors.grey])
            ),
            child: Form(
              key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 130.0,bottom: 60),
                        child: Text("Sign Up",style: TextStyle(fontSize: 45,color: Colors.white),textAlign: TextAlign.center,),
                      ),
                      textFormField(controller: nameController,hintText: "Name",keyBoard: TextInputType.name,prefixIcon: Icons.drive_file_rename_outline),
                      SizedBox(height: 25,),
                      textFormField(controller: phoneController,hintText: "Phone",keyBoard: TextInputType.phone,prefixIcon: Icons.phone),
                      SizedBox(height: 25,),
                      textFormField(controller: emailController,hintText: "Email",keyBoard: TextInputType.emailAddress,prefixIcon: Icons.email),
                      SizedBox(height: 25,),
                      textFormField(controller: passwordController, hintText: "Password",suffixIcon: SignUpCubit.get(context).icon,func:SignUpCubit.get(context).changeHintText,isHint:SignUpCubit.get(context).isHint ,prefixIcon: Icons.password),
                      SizedBox(height: 25,),
                      textFormField(controller: passwordConfirmController,hintText: "Confirm Password",isHint: true,pass: passwordController,confirmpass: passwordConfirmController,prefixIcon: Icons.password),
                      SizedBox(height: 25,),
                      MaterialButton(
                        onPressed: (){
                          if(formKey.currentState!.validate())
                          SignUpCubit.get(context).postRegister(name: nameController.text, phone: phoneController.text, email:emailController.text, password: passwordController.text);
                        },
                        color: Colors.grey,
                        minWidth: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: state is SignUpLoadingState ? CircularProgressIndicator(color: Colors.white,) : Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 25),),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ignore: prefer_const_constructors
                          Text("Already Don't have an account?"),
                          // ignore: prefer_const_constructors
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                          }, child: Text("Sign In",style: TextStyle(color: Colors.white),)),
                        ],),
                    ],
                  ),
                ),
              ),
          ),
          ),
        listener: (context,state){
          if(state is SignUpSuccessState){
            toast(Colors.green,"Succeded",context);
          }
          if(state is SignUpErrorState){
            toast(Colors.red,state.error,context);
          }
          if(state is UserSuccessState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeLayout()));
          }
        },
      ),
    );
  }
}
