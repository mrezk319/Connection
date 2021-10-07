import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:social_app_2/layout/cubit/cubit.dart';
import 'package:social_app_2/layout/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:social_app_2/layout/home_layout.dart';
import 'package:social_app_2/modeules/settings/settings_screen.dart';
class Post extends StatelessWidget {
var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: BlocProvider.of<HomeCubit>(context),
    child: BlocConsumer<HomeCubit,HomeStates>(
      listener: (context,state){
        if(state is uploadPostImageSuccessState || state is postUploadSuccessState){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeLayout()));
        }
      },
      builder: (context,state){

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text("Create Post"),
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                HomeCubit.get(context).postImage = null;
                Navigator.pop(context);},
            ),
            actions: [
              TextButton(onPressed: (){
                if(HomeCubit.get(context).postImage == null)
                  HomeCubit.get(context).uploadPost(date:  DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now()),postText: textController.text);
                else
                  HomeCubit.get(context).uploadPostImage(
                    postText: textController.text,
                    date: DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now()),
                  );
            }, child: Text("POST",style: TextStyle(color: Colors.blue),))
            ],
          ),

        body:HomeCubit.get(context).userModel == null ? Center(child: CircularProgressIndicator(color: Colors.red,)): Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                if(state is uploadPostImageLoadingState || state is postUploadLoadingState)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LinearProgressIndicator(color: Colors.blue,),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage((HomeCubit.get(context).userModel!.image??"")),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text((HomeCubit.get(context).userModel!.name??""),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 5,),
                    ],
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(border: InputBorder.none,hintText: "What is on your mind ..."),
                    maxLines: 150,
                  ),
                ),
                if(HomeCubit.get(context).postImage != null)
                  Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 230,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                child: Image.file(HomeCubit.get(context).postImage as File),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: CircleAvatar(
                              child: Icon(
                                Icons.close,
                                size: 20,
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            onTap: () {
                              HomeCubit.get(context).removePostImage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: InkWell(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image,color: Colors.blue,),
                        Text(" Add photo",style: TextStyle(color:Colors.blue),),
                      ],
                    ),
                    onTap: (){
                      HomeCubit.get(context).getPostImage();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),);
  }
}
