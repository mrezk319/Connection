import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_2/layout/home_layout.dart';
import 'package:social_app_2/modeules/logIn/cubit/logIn_cubit.dart';
import 'package:social_app_2/modeules/logIn/cubit/logIn_states.dart';
import 'package:social_app_2/modeules/signUp/sign_up.dart';
import 'package:social_app_2/shared/components/components.dart';
import 'package:social_app_2/shared/network/local.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignIn extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>LogInCubit(),
      child: BlocConsumer<LogInCubit,LogInStates>(
        builder: (context,state)=>Scaffold(
          body: Form(
            key: formKey,
            child: Container(
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                  gradient: LinearGradient(colors: [Colors.white,Colors.grey])
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 88.0,),
                      child: Image.asset('assets/images/login.png',width: 300,height: 300,),
                    ),
                    textFormField(controller: emailController,hintText: "Email",keyBoard: TextInputType.emailAddress,prefixIcon: Icons.person),
                    // ignore: prefer_const_constructors
                    SizedBox(height: 15,),
                    textFormField(controller: passwordController,hintText: "Password",isHint: true,prefixIcon: Icons.password),
                    // ignore: prefer_const_constructors
                    SizedBox(height: 15,),
                    MaterialButton(
                      onPressed: (){
                        if(formKey.currentState!.validate()) {
                          LogInCubit.get(context).postLogIn(
                              email: emailController.text,
                              password: passwordController.text);
                          print(FirebaseAuth.instance.currentUser!.uid);
                        }
                      },
                      color: Colors.grey,
                      minWidth: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: state is LogInLoadingState?CircularProgressIndicator(color: Colors.white,) : Text("LogIn",style: TextStyle(color: Colors.white,fontSize: 25),),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: prefer_const_constructors
                        Text("Don't have an account?"),
                        // ignore: prefer_const_constructors
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                        }, child: Text("Sign Up",style: TextStyle(color: Colors.white),)),
                      ],),
                  ],
                ),
              ),
            ),
          ),
        ),
        listener: (context,state){
          if(state is LogInSuccessState){
            toast(Colors.green,"Succeded",context);
            CacheHelper.saveData(key: "isSigned", value: true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeLayout()));
          }
          if(state is LogInErrorState){
            toast(Colors.red,state.error,context);
          }
        },
      ),
    );
  }
}