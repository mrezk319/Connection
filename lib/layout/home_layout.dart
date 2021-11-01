import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Social_App/layout/cubit/cubit.dart';
import 'package:Social_App/layout/cubit/states.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:Social_App/modeules/logIn/log_in.dart';
import 'package:Social_App/modeules/post/post_screen.dart';
import 'package:Social_App/modeules/signUp/cubit/signup_states.dart';
import 'package:Social_App/shared/components/components.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:Social_App/shared/network/local.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomeCubit>(context),
      child: BlocConsumer<HomeCubit, HomeStates>(
          builder: (context, state) => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    HomeCubit.get(context)
                        .titles[HomeCubit.get(context).currentIndex],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notification_important_outlined),
                      onPressed: () {

                      },
                    ),
                    MaterialButton(onPressed: (){
                      CacheHelper.saveData(key: "isSigned", value: false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
                    },child: Text("Sign Out",style: TextStyle(color: Colors.blue),),)
                  ],
                ),
                body: HomeCubit.get(context)
                    .screens[HomeCubit.get(context).currentIndex],
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Post()));
                  },
                  child: Icon(
                    Icons.post_add,
                    size: 32,
                  ),
                  backgroundColor: Colors.grey,
                ),
                bottomNavigationBar: AnimatedBottomNavigationBar(
                  activeColor: Colors.red,
                  splashColor: Colors.amberAccent,
                  icons: [
                    Icons.home,
                    Icons.chat_sharp,
                    Icons.people_alt_outlined,
                    Icons.settings,
                  ],
                  onTap: (index) {
                    HomeCubit.get(context).changeIndex(index);
                  },
                  activeIndex: HomeCubit.get(context).currentIndex,
                  gapLocation: GapLocation.center,
                ),
              ),
          listener: (context, state) {}),
    );
  }
}
