import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:Social_App/layout/cubit/cubit.dart';
import 'package:Social_App/layout/cubit/states.dart';
import 'package:Social_App/models/post_model.dart';
import 'package:Social_App/modeules/editProfile/edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Social_App/modeules/logIn/log_in.dart';
import 'package:Social_App/modeules/signUp/cubit/signup_states.dart';
import 'package:Social_App/shared/network/local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Setings extends StatelessWidget {
  const Setings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: BlocProvider.of<HomeCubit>(context)..getUserData(uid: FirebaseAuth.instance.currentUser!.uid)..getMyPosts(),
    child: BlocConsumer<HomeCubit,HomeStates>(
      builder: (context,state)=> state is getUserLoadingState ? Center(child: CircularProgressIndicator(color: Colors.red,)):RefreshIndicator(
        color: Colors.red,
        onRefresh: () async{
          await HomeCubit.get(context)..getMyPosts();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 230,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        child: ClipRRect(
                          child: Image.network(
                            HomeCubit.get(context).userModel!.cover??"",
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 65,
                    child: CircleAvatar(
                      radius: 61,
                      backgroundImage: NetworkImage(HomeCubit.get(context).userModel!.image??""),
                    ),
                  ),
                ],),
              Center(child: Text(HomeCubit.get(context).userModel!.name??"",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 17))),
              SizedBox(height: 7,),
              Center(child: Text(HomeCubit.get(context).userModel!.bio??"",style: Theme.of(context).textTheme.caption,)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 7),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("100",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                            SizedBox(height: 5,),
                            Text("Posts",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14))
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("256",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                            SizedBox(height: 5,),
                            Text("Photos",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14))
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("10k",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                            SizedBox(height: 5,),
                            Text("Followers",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14))
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("64",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                            SizedBox(height: 5,),
                            Text("Following",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14))
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){}, child: Text("Add Photo",style: TextStyle(color: Colors.blue),),)),
                  SizedBox(width: 15,),
                  OutlinedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                  }, child: Icon(Icons.edit_rounded,color: Colors.blue,),),
                ],
              ),
            SizedBox(height: 20,),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildPostItem(HomeCubit
                          .get(context)
                          .myposts[index], context, index),
                  separatorBuilder: (context, index) =>
                      SizedBox(
                        height: 3,
                      ),
                  itemCount: HomeCubit
                      .get(context)
                      .myposts
                      .length
              ) ,
            ],
          ),
        ),
      ),
      listener: (context,state){},
    ),
    );
  }

  Widget buildPostItem(PostModel? model, context, index) {
    return model!.uid == HomeCubit.get(context).userModel!.uid
    ? Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage((model.image ?? "")),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text((model.name ?? ""),
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ),
                      Text(
                        (model.date ?? ""),
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption,
                      )
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Divider(
                color: Colors.grey,
                height: 1,
              ),
            ),
            Text(
              (model.postText ?? ""),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
            // Container(
            //   width: double.infinity,
            //   child: Wrap(
            //     crossAxisAlignment: WrapCrossAlignment.start,
            //     children: [
            //       InkWell(
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 3.0),
            //           child: Container(
            //             height: 18,
            //             child: MaterialButton(
            //               child: Text(
            //                 "#flutter",
            //                 style: TextStyle(color: Colors.blue),
            //               ),
            //               onPressed: () {},
            //               height: 10,
            //               minWidth: 5,
            //               padding: EdgeInsets.zero,
            //             ),
            //           ),
            //         ),
            //         onTap: () {},
            //       ),
            //       InkWell(
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 3.0),
            //           child: Container(
            //             height: 18,
            //             child: MaterialButton(
            //               child: Text(
            //                 "#MobileDev",
            //                 style: TextStyle(color: Colors.blue),
            //               ),
            //               onPressed: () {},
            //               height: 10,
            //               minWidth: 5,
            //               padding: EdgeInsets.zero,
            //             ),
            //           ),
            //         ),
            //         onTap: () {},
            //       ),
            //     ],
            //   ),
            // ),
            if(model.postImage != "")
              Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    (model.postImage ?? ""),
                  ),
                ),
              ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                    ),
                    Text((HomeCubit
                        .get(context)
                        .myLikes[index].toString())),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.message_outlined,
                      color: Colors.amberAccent,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text("0 comment"),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Colors.grey,
                height: 1,
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundImage: NetworkImage(HomeCubit
                      .get(context)
                      .userModel!
                      .image ?? ""),
                ),
                SizedBox(
                  width: 15,
                ),
                TextButton(
                    onPressed: () {}, child: Text("Write a comment ...")),
                Spacer(),
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color:Colors.grey,
                      ),
                      Text("Like",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  onTap: () async {
                    HomeCubit
                        .get(context)
                        .myisLikes[index] = !HomeCubit
                        .get(context)
                        .myisLikes[index];
                    await FirebaseFirestore.instance.collection('posts').doc(
                        HomeCubit
                            .get(context)
                            .mypostsId[index]).collection('Likes').doc(HomeCubit
                        .get(context)
                        .userModel!
                        .uid).get().then((value) {
                      value.exists ?
                      HomeCubit.get(context).disMyLike(HomeCubit
                          .get(context)
                          .mypostsId[index], index) : HomeCubit.get(context)
                          .likeMyPost(HomeCubit
                          .get(context)
                          .mypostsId[index], index);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ):SizedBox(height: 0,);
  }

}
