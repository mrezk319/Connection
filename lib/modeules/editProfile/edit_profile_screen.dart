import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:social_app_2/layout/cubit/cubit.dart';
import 'package:social_app_2/layout/cubit/states.dart';
import 'package:social_app_2/modeules/logIn/log_in.dart';
import 'package:social_app_2/shared/components/components.dart';
import 'package:social_app_2/shared/network/local.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomeCubit>(context),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if(state is uploadCoverImagePickerSuccessState || state is uploadProfileImagePickerSuccessState || state is updateUploadDataUser)
            {
              toast(Colors.green, "Updates succesfully", context);
            }
        },
        builder: (context, state) {
          nameController.text = HomeCubit.get(context).userModel!.name!;
          phoneController.text = HomeCubit.get(context).userModel!.phone!;
          bioController.text = HomeCubit.get(context).userModel!.bio!;
          var profileImage = HomeCubit.get(context).profileImage;
          var coverImage = HomeCubit.get(context).coverImage;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 0,
              title: Text("Edit Profile"),
              leading: IconButton(onPressed: (){
                Navigator.pop(context);
                },
                  icon: Icon(Icons.arrow_back_ios)),
              actions: [
                TextButton(
                    onPressed: () {
                      HomeCubit.get(context).updateUser(name: nameController.text,bio: bioController.text,phone: phoneController.text,);
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.blue),
                    )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(state is uploadUserLoadingState)
                      LinearProgressIndicator(color: Colors.blue,),
                    SizedBox(height: 10,),
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
                                    child: (coverImage != null ? Image.file(coverImage,fit: BoxFit.cover,) : Image.network((HomeCubit.get(context).userModel!.cover??""),fit: BoxFit.cover,)),
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
                                    Icons.camera_alt,
                                    size: 20,
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                onTap: () {
                                  HomeCubit.get(context).getCoverImage();
                                },
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 65,
                              child: CircleAvatar(
                                radius: 61,
                                backgroundImage: (profileImage != null ? FileImage(profileImage) : NetworkImage(HomeCubit.get(context).userModel!.image??"")) as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                onTap: () {
                                  HomeCubit.get(context).getProfileImage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if(HomeCubit.get(context).profileImage != null || HomeCubit.get(context).coverImage != null )
                    Row(children: [
                      if(HomeCubit.get(context).profileImage != null)
                      Expanded(child: Column(
                        children: [
                          MaterialButton(
                            color: Colors.blue,
                            minWidth: double.infinity,
                            onPressed: (){
                            HomeCubit.get(context).uploadprofile(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                          },child: Text("Update Profile",style: TextStyle(color: Colors.white),),),
                         if( state is uploadProfileImagePickerLoadingState)
                           LinearProgressIndicator(color: Colors.blue,)
                        ],
                      )),
                      if(HomeCubit.get(context).profileImage != null && HomeCubit.get(context).coverImage != null )
                      SizedBox(width: 15,),
                      if(HomeCubit.get(context).coverImage != null)
                      Expanded(child: Column(
                        children: [
                          MaterialButton(
                            color: Colors.blue,
                            minWidth: double.infinity,
                            onPressed: (){
                            HomeCubit.get(context).uploadCover(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                          },child: Text("Update Cover",style: TextStyle(color: Colors.white),),),
                          if( state is uploadCoverImagePickerLoadingState)
                            LinearProgressIndicator(color: Colors.blue,)
                        ],
                      )),
                    ],),
                    SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        controller: nameController,
                        hintText: "Name",
                        prefixIcon: Icons.person),
                    SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        controller: bioController,
                        hintText: "Bio",
                        prefixIcon: Icons.textsms_outlined),
                    SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        controller: phoneController,
                        hintText: "Phone",
                        prefixIcon: Icons.phone,
                        keyBoard: TextInputType.phone),
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
