import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/core/show_toast_meassage.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class AddOrRemoveForSendMessage extends StatefulWidget {
  const AddOrRemoveForSendMessage({super.key});

  @override
  State<AddOrRemoveForSendMessage> createState() =>
      _AddOrRemoveForSendMessageState();
}

class _AddOrRemoveForSendMessageState extends State<AddOrRemoveForSendMessage> {
  List<Widget> finalList = [
    Center(
      child:
          LoadingAnimationWidget.halfTriangleDot(color: Colors.green, size: 30),
    )
  ];

  List allowed = [];
  List alredyAdded = [];
  List<String> allowedUID = [];
  List<String> addedUID = [];

  void buildwidget() async {
    List<Widget> listForMessages = [];

    List<Widget> listOfWidget = [];
    for (int i = 0; i < alredyAdded.length; i++) {
      listOfWidget.add(
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(60, 114, 114, 114),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(60, 114, 114, 114),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: alredyAdded[i]['img'] == 'null'
                      ? Center(
                          child: Text(
                            alredyAdded[i]['userName']
                                .toString()
                                .substring(0, 2),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: alredyAdded[i]['img'],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return LoadingAnimationWidget.newtonCradle(
                              color: Colors.green,
                              size: 30,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alredyAdded[i]['userName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(alredyAdded[i]['userEmail']),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  await FirebaseDatabase.instance
                      .ref(
                          "/messages/user/${FirebaseAuth.instance.currentUser!.uid}/contacts/${alredyAdded[i]['uid']}")
                      .remove();
                  allowed.add(alredyAdded[i]);
                  alredyAdded.removeAt(i);
                  showToast("Removed");
                  buildwidget();
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
        ),
      );
    }
    listForMessages
        .add(const Center(child: Text("Previously Added for sent message")));
    listForMessages.addAll(listOfWidget);
    if (listOfWidget.isEmpty) {
      listForMessages.add(Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(20),
        color: const Color.fromARGB(60, 114, 114, 114),
        child: const Center(child: Text("You added 0 for sent messages")),
      ));
    }
    listForMessages.add(const Divider());

    listOfWidget = [];
    for (var i = 0; i < allowed.length; i++) {
      if (!addedUID.contains(allowed[i]['uid'])) {
        listOfWidget.add(
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(60, 114, 114, 114),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(60, 114, 114, 114),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: allowed[i]['img'] == 'null'
                        ? Center(
                            child: Text(
                              allowed[i]['userName'].toString().substring(0, 2),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: allowed[i]['img'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
                              return LoadingAnimationWidget.newtonCradle(
                                color: Colors.green,
                                size: 30,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allowed[i]['userName'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(allowed[i]['userEmail']),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    await FirebaseDatabase.instance
                        .ref(
                            "/messages/user/${FirebaseAuth.instance.currentUser!.uid}/contacts/${allowed[i]['uid']}")
                        .set(allowed[i]);
                    alredyAdded.add(allowed[i]);
                    allowed.removeAt(i);
                    showToast("Added");
                    buildwidget();
                  },
                  icon: const Icon(Icons.add_circle_outline_outlined),
                ),
              ],
            ),
          ),
        );
      }
    }
    listForMessages
        .add(const Center(child: Text("You can add them for send messages")));
    listForMessages.addAll(listOfWidget);
    if (listOfWidget.isEmpty) {
      listOfWidget.add(Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(20),
        color: const Color.fromARGB(60, 114, 114, 114),
        child: const Center(child: Text("You added 0 for sent messages")),
      ));
    }

    setState(() {
      finalList = listForMessages;
    });
  }

  void getData() async {
    final data =
        await FirebaseDatabase.instance.ref("/messages/allowed/").get();
    if (data.exists && data.value != null) {
      Map<String, dynamic> dataMap =
          Map<String, dynamic>.from(jsonDecode(jsonEncode(data.value)));
      List<String> keySortedList = dataMap.keys.toList()..sort();

      for (int index = 0; index < keySortedList.length; index++) {
        final x = await FirebaseDatabase.instance
            .ref("/user/${keySortedList[index]}/")
            .get();
        if (x.exists && x.value != null) {
          allowed.add(x.value);
          allowedUID.add(keySortedList[index]);
        }
      }
    }
    final added = await FirebaseDatabase.instance
        .ref(
            "/messages/user/${FirebaseAuth.instance.currentUser!.uid}/contacts/")
        .get();
    if (added.exists && added.value != null) {
      Map<String, dynamic> addedMap =
          Map<String, dynamic>.from(jsonDecode(jsonEncode(added.value)));
      List<String> keySortedList = addedMap.keys.toList()..sort();
      for (int index = 0; index < keySortedList.length; index++) {
        final x = await FirebaseDatabase.instance
            .ref("/user/${keySortedList[index]}/")
            .get();
        if (x.exists && x.value != null) {
          alredyAdded.add(x.value);
          addedUID.add(keySortedList[index]);
        }
      }
    }
    setState(() {
      allowed;
      alredyAdded;
    });
    buildwidget();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const HomeDrawer(),
      body: ListView(
        padding: const EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 10),
        children: finalList,
      ),
    );
  }
}
