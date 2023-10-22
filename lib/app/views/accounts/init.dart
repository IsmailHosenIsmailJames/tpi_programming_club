import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpi_programming_club/app/views/pages/home/home.dart';

import 'login/login.dart';

class InIt extends StatelessWidget {
  const InIt({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LogIn();
        }
      },
    );
  }
}
