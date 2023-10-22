import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tpi_programming_club/app/views/accounts/account_info_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final accountInfo = Get.put(AccountInfoController());
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profile",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
