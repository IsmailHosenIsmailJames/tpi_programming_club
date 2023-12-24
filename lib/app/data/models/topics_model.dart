// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TopicsModel welcomeFromJson(String str) =>
    TopicsModel.fromJson(json.decode(str));

String welcomeToJson(TopicsModel data) => json.encode(data.toJson());

class TopicsModel {
  String id;
  String name;
  String description;
  String img;
  String like;
  String share;
  String classNumber;

  TopicsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.img,
    required this.like,
    required this.share,
    required this.classNumber,
  });

  factory TopicsModel.fromJson(Map<String, dynamic> json) => TopicsModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        img: json["img"],
        like: json["like"],
        share: json["share"],
        classNumber: json["classNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "img": img,
        "like": like,
        "share": share,
        "classNumber": classNumber,
      };
}
