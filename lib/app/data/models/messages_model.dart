import 'dart:convert';

MessagesModel messagesModelFromMap(String str) =>
    MessagesModel.fromMap(json.decode(str));

String messagesModelToMap(MessagesModel data) => json.encode(data.toMap());

class MessagesModel {
  int time;
  String messages;
  bool isReply;
  int replayMessageTime;
  String uid;

  MessagesModel({
    required this.time,
    required this.messages,
    required this.isReply,
    required this.replayMessageTime,
    required this.uid,
  });

  factory MessagesModel.fromMap(Map<String, dynamic> json) => MessagesModel(
        time: json["time"],
        messages: json["messages"],
        isReply: json["isReply"],
        replayMessageTime: json["replayMessageTime"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "time": time,
        "messages": messages,
        "isReply": isReply,
        "replayMessageTime": replayMessageTime,
        "uid": uid,
      };
}
