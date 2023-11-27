import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tpi_programming_club/app/core/show_toast_meassage.dart';
import 'package:tpi_programming_club/app/views/accounts/account_info_controller.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final accountInfo = Get.put(AccountInfoController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const HomeDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Can others message you for help ?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Obx(
                () => Switch.adaptive(
                    value: accountInfo.allowMessages.value,
                    onChanged: (value) async {
                      try {
                        await FirebaseDatabase.instance
                            .ref(
                                "/user/${FirebaseAuth.instance.currentUser!.uid}/allowMessages")
                            .set(value);

                        accountInfo.allowMessages.value = value;
                        if (value == true) {
                          await FirebaseDatabase.instance
                              .ref(
                                  "messages/allowed/${FirebaseAuth.instance.currentUser!.uid}")
                              .set(true);
                          showToast("Now people can message you for help.");
                        } else {
                          await FirebaseDatabase.instance
                              .ref(
                                  "messages/allowed/${FirebaseAuth.instance.currentUser!.uid}")
                              .remove();
                          showToast("People can't message you");
                        }
                      } catch (e) {
                        showToast(e.toString());
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
