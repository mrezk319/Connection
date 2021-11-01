import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Social_App/layout/cubit/cubit.dart';
import 'package:Social_App/layout/cubit/states.dart';
import 'package:Social_App/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  UserModel? model;

  ChatScreen(this.model);

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          HomeCubit.get(context).getMessages(receiverId: (model!.uid ?? ""));
          return BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  title: chatName(this.model, context),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                body: HomeCubit
                  .get(context)
                  .messagesList == null ? Center(child: CircularProgressIndicator(color: Colors.red,),):Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8, right: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: HomeCubit
                            .get(context)
                            .messagesList!.isEmpty ? Center(child: Text("Chat Is Empty",style: TextStyle(fontSize: 25,color: Colors.black26),)) : ListView.separated(
                            itemBuilder: (context, index) {
                              if (HomeCubit
                                  .get(context)
                                  .messagesList![index]
                                  .senderId ==
                                  HomeCubit
                                      .get(context)
                                      .userModel!
                                      .uid)
                                return mineMessage((HomeCubit
                                    .get(context)
                                    .messagesList![index].text??""));
                              return otherMessage((HomeCubit
                                  .get(context)
                                  .messagesList![index].text??""));
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(
                                  height: 5,
                                ),
                            itemCount:
                            HomeCubit
                                .get(context)
                                .messagesList!
                                .length),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "    Write your message...",
                                        border: InputBorder.none,
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () {},
                                        )),
                                    controller: textController,
                                  )),
                              Container(
                                color: Colors.blue,
                                child: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    HomeCubit.get(context).sendMessage(
                                        text: textController.text,
                                        recieverId: (model!.uid ?? ""),
                                        date:
                                        DateFormat("yyyy-MM-dd hh-mm-ss")
                                            .format(DateTime.now()));
                                    textController.text = "";
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget chatName(model, context) =>
      Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage((model.image ??
                "https://image.freepik.com/free-photo/top-view-chopping-board-with-delicious-kebab-lemon_23-2148685530.jpg")),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            model.name ?? "",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
          )
        ],
      );

  Widget mineMessage(String text) =>
      Align(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(text),
          ),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          ),
        ),
        alignment: AlignmentDirectional.centerEnd,
      );

  Widget otherMessage(String text) =>
      Align(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(text),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        alignment: AlignmentDirectional.centerStart,
      );
}