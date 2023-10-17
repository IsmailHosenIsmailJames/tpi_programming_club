import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../drawer/drawer.dart';

class ClassesOnTopics extends StatefulWidget {
  final String path;
  final String topicsName;
  const ClassesOnTopics(
      {super.key, required this.path, required this.topicsName});

  @override
  State<ClassesOnTopics> createState() => _ClassesOnTopicsState();
}

class _ClassesOnTopicsState extends State<ClassesOnTopics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topicsName,
        ),
      ),
      drawer: const HomeDrawer(),
      body: FutureBuilder(
        future: FirebaseDatabase.instance.ref().child(widget.path).get(),
        builder: (context, snapshot) {
          return const Text("Loaded Data");
        },
      ),
    );
  }
}
