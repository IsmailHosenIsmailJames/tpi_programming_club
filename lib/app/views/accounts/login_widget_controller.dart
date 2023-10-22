import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountWidgetController extends GetxController {
  Rx<Widget> signUp = const Center(
    child: Text(
      "Sign Up",
      style: TextStyle(fontSize: 26, color: Colors.white),
    ),
  ).obs;

  Rx<Widget> login = const Center(
      child: Text(
    "LogIn",
    style: TextStyle(fontSize: 26, color: Colors.white),
  )).obs;
}
