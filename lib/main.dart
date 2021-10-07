import 'package:flutter/material.dart';
import 'package:social_app_2/layout/cubit/cubit.dart';
import 'package:social_app_2/layout/home_layout.dart';
import 'package:social_app_2/modeules/logIn/log_in.dart';
import 'package:social_app_2/shared/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app_2/shared/network/local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  bool chooseFirstPagse = CacheHelper.getDate(key: "isSigned") == null ? false : CacheHelper.getDate(key: "isSigned") ;
  print(chooseFirstPagse);
  runApp(MyApp(chooseFirstPagse));
}

class MyApp extends StatelessWidget {
bool whoIsFirst;
MyApp(this.whoIsFirst);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create:(context)=> HomeCubit()..changeIndex(3)),
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home:whoIsFirst ?HomeLayout() : SignIn(),
      theme: ThemeData(
        primarySwatch: Colors.grey
      ),
    ));
  }
}
