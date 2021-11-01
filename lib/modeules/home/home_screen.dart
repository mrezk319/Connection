import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Social_App/layout/cubit/cubit.dart';
import 'package:Social_App/layout/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Social_App/models/post_model.dart';
import 'package:Social_App/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
          return BlocProvider.value(
              value: BlocProvider.of<HomeCubit>(context)..getAllPosts()
            ..getUserData(uid: FirebaseAuth.instance.currentUser!.uid),
              child: BlocConsumer<HomeCubit, HomeStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return RefreshIndicator(
                    color: Colors.red,
                    onRefresh: () async{
                      await HomeCubit.get(context)..getAllPosts();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            children: [
                              Card(
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          'https://image.freepik.com/free-photo/cheerful-positive-young-european-woman-with-dark-hair-broad-shining-smile-points-with-thumb-aside_273609-18325.jpg',
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Communicate with friends",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                elevation: 5,
                              ),
                              HomeCubit
                                  .get(context)
                                  .Likes != HomeCubit
                                  .get(context)
                                  .isLikes.length ?
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      buildPostItem(HomeCubit
                                          .get(context)
                                          .posts[index], context, index),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 3,
                                      ),
                                  itemCount: HomeCubit
                                      .get(context)
                                      .posts
                                      .length
                              ) :
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80.0, vertical: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Refreshing"),
                                    SizedBox(height: 15,),
                                    LinearProgressIndicator(color: Colors.blue,)
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              )
          );
  }

  Widget buildPostItem(PostModel? model, context, index) {
    return Card(
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
                    backgroundImage: NetworkImage((model!.image ?? "")),
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
                        .Likes[index].toString())),
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
                        .isLikes[index] = !HomeCubit
                        .get(context)
                        .isLikes[index];
                    await FirebaseFirestore.instance.collection('posts').doc(
                        HomeCubit
                            .get(context)
                            .postsId[index]).collection('Likes').doc(HomeCubit
                        .get(context)
                        .userModel!
                        .uid).get().then((value) {
                      value.exists ?
                      HomeCubit.get(context).disLike(HomeCubit
                          .get(context)
                          .postsId[index], index) : HomeCubit.get(context)
                          .likePost(HomeCubit
                          .get(context)
                          .postsId[index], index);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}