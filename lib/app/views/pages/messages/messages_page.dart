import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
              // FutureBuilder(future: FirebaseDatabase.instance.ref(""), builder: builder),
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(60, 158, 158, 158),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {},
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
