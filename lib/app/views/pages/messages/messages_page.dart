import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/views/pages/messages/send_messages.dart';

import '../../../data/models/account_model.dart';
import 'add_remove_for_send_message.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 5, right: 5),
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color.fromARGB(60, 158, 158, 158),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            scrollDirection: Axis.horizontal,
            children: [
              FutureBuilder(
                future: FirebaseDatabase.instance
                    .ref(
                        "/messages/user/${FirebaseAuth.instance.currentUser!.uid}/contacts")
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data;
                    if (data!.exists) {
                      final valueData = data.value!;
                      Map<String, dynamic> valueMap = Map<String, dynamic>.from(
                          jsonDecode(jsonEncode(valueData)));
                      List<Widget> wgt = [];
                      valueMap.forEach((key, value) {
                        String name = value['userName'];
                        String imgURL = value['img'];
                        wgt.add(
                          GestureDetector(
                            onTap: () {
                              AccountModel accountModel = AccountModel(
                                userName: name,
                                uid: value['uid'],
                                userEmail: value['userEmail'],
                                allowMessages: true,
                                img: imgURL,
                                posts: [],
                                followers: [],
                              );
                              Get.to(() =>
                                  SendMessages(accountModel: accountModel));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 3, right: 3),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor:
                                    const Color.fromARGB(60, 146, 145, 145),
                                backgroundImage: imgURL != 'null'
                                    ? CachedNetworkImageProvider(imgURL)
                                    : null,
                                child: imgURL == 'null'
                                    ? Center(
                                        child: Text(
                                          name.substring(0, 2),
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        );
                      });
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: wgt,
                      );
                    } else {
                      return const Text("No Data Exits");
                    }
                  }
                  return LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.green, size: 30);
                },
              ),
              Container(
                height: 70,
                width: 70,
                margin: const EdgeInsets.only(left: 3, right: 3),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(60, 33, 214, 184),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => const AddOrRemoveForSendMessage());
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
