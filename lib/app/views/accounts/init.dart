import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login/login.dart';

class InIt extends StatelessWidget {
  const InIt({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) =>
          snapshot.hasData ? const LogIn() : const LogIn(),
    );
  }
}
