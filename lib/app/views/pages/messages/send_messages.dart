import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/standalone.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/data/models/account_model.dart';
import 'package:tpi_programming_club/app/data/models/messages_model.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class SendMessages extends StatefulWidget {
  const SendMessages({super.key, required this.accountModel});
  final AccountModel accountModel;

  @override
  State<SendMessages> createState() => _SendMessagesState();
}

class _SendMessagesState extends State<SendMessages> {
  final inputController = TextEditingController();
  List<Widget> buildMessagesWidget(Map<String, dynamic> messagesMap) {
    List<Widget> messages = [
      LoadingAnimationWidget.waveDots(color: Colors.green, size: 30)
    ];
    List<Widget> temWidgetList = [];

    List<String> keySortedMap = messagesMap.keys.toList()..sort();

    for (int index = 0; index < keySortedMap.length; index++) {
      MessagesModel temMessagesModel = MessagesModel(
        time: messagesMap[keySortedMap[index]]['time'],
        messages: messagesMap[keySortedMap[index]]['messages'],
        isReply: messagesMap[keySortedMap[index]]['isReplay'] ?? false,
        replayMessageTime: messagesMap[keySortedMap[index]]
            ['replayMessageTime'],
        uid: messagesMap[keySortedMap[index]]['uid'],
      );
      if (temMessagesModel.uid == FirebaseAuth.instance.currentUser!.uid) {
        temWidgetList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Color.fromARGB(57, 24, 148, 127),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Date : ${DateTime.fromMillisecondsSinceEpoch(temMessagesModel.time)}",
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      temMessagesModel.messages,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        temWidgetList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Color.fromARGB(60, 33, 149, 243),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date : ${DateTime.fromMillisecondsSinceEpoch(temMessagesModel.time)}",
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      temMessagesModel.messages,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
    messages = temWidgetList;
    if (messages.isEmpty) {
      messages = [const Center(child: Text("No messages are avilable"))];
    }

    return messages.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accountModel.userName),
      ),
      drawer: const HomeDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref(
                        "/messages/user/${FirebaseAuth.instance.currentUser!.uid}/messages/${widget.accountModel.uid}")
                    .onValue,
                builder: (contex, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.snapshot.value != null) {
                    Map<String, dynamic> tem = Map<String, dynamic>.from(
                      jsonDecode(
                        jsonEncode(snapshot.data!.snapshot.value),
                      ),
                    );
                    return ListView(
                      reverse: true,
                      children: buildMessagesWidget(tem),
                    );
                  }

                  if (snapshot.data != null &&
                      !snapshot.data!.snapshot.exists) {
                    return const Text("No messages found");
                  }
                  return LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.green,
                      rightDotColor: Colors.blue,
                      size: 30);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: inputController,
                    minLines: 1,
                    maxLines: 100,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (inputController.text.isNotEmpty) {
                      var detroit = getLocation('Asia/Dhaka');
                      var now = TZDateTime.now(detroit);
                      MessagesModel tem = MessagesModel(
                        time: now.millisecondsSinceEpoch,
                        messages: inputController.text,
                        isReply: false,
                        replayMessageTime: 0,
                        uid: FirebaseAuth.instance.currentUser!.uid,
                      );
                      await FirebaseDatabase.instance
                          .ref(
                              "/messages/user/${FirebaseAuth.instance.currentUser!.uid}/messages/${widget.accountModel.uid}/${now.millisecondsSinceEpoch}")
                          .set(tem.toMap());
                      await FirebaseDatabase.instance
                          .ref(
                              "/messages/user/${widget.accountModel.uid}/messages/${FirebaseAuth.instance.currentUser!.uid}/${now.millisecondsSinceEpoch}")
                          .set(tem.toMap());
                      inputController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
