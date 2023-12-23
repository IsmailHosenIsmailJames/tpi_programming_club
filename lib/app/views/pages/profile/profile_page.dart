import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/core/image_picker.dart';
import 'package:tpi_programming_club/app/core/show_toast_meassage.dart';
import 'package:tpi_programming_club/app/views/accounts/account_info_controller.dart';

import '../../../themes/const_theme_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final accountInfo = Get.put(AccountInfoController());
  IconData postHideIcon = Icons.keyboard_arrow_right;
  IconData fllowersHideIcon = Icons.keyboard_arrow_right;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            height: 150,
            width: 150,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.green.shade300,
            ),
            child: accountInfo.img.value == 'null'
                ? Text(
                    accountInfo.name.value.substring(0, 2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Obx(
                      () => CachedNetworkImage(
                        imageUrl: accountInfo.img.value,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              String? url;
              if (kIsWeb) {
                final tem = await pickPhotoWeb(
                    "/user/${FirebaseAuth.instance.currentUser!.uid}/img");
                url = tem.url;
              } else {
                final tem = await pickPhotoMobile(
                    "/user/${FirebaseAuth.instance.currentUser!.uid}/img");
                url = tem.url;
              }
              if (url != null) {
                FirebaseDatabase.instance
                    .ref("/user/${FirebaseAuth.instance.currentUser!.uid}/img")
                    .set(url);
                accountInfo.img.value = url;
                // ignore: use_build_context_synchronously
                if (Navigator.canPop(context)) Navigator.pop(context);
              } else {
                showToast("Upload is not successful");
              }
            },
            child: const Text("Change Profile Photo"),
          ),
        ),
        const Divider(),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.person,
              size: 36,
            ),
            const SizedBox(
              width: 20,
            ),
            Obx(
              () => Text(
                accountInfo.name.value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                TextEditingController name =
                    TextEditingController(text: accountInfo.name.value);
                final key = GlobalKey<FormState>();
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: key,
                      child: SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.length >= 3) {
                                  return null;
                                } else {
                                  return "Your name is not correct...";
                                }
                              },
                              controller: name,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                focusedBorder: ConstantThemeData()
                                    .onFocusOutlineInputBorder,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(width: 3),
                                ),
                                labelText: "Name",
                                hintText: "Type your name here...",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                maximumSize: const Size(380, 50),
                                minimumSize: const Size(380, 50),
                                backgroundColor:
                                    ConstantThemeData().primaryColour,
                              ),
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  try {
                                    await FirebaseDatabase.instance
                                        .ref(
                                            "/user/${FirebaseAuth.instance.currentUser!.uid}/userName")
                                        .set(name.text);
                                    // ignore: use_build_context_synchronously
                                    if (Navigator.canPop(context)) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    }
                                    accountInfo.name.value = name.text;
                                  } catch (e) {
                                    showToast(e.toString());
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.done,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.email,
              size: 33,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              accountInfo.email.value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            const CircleAvatar(
              radius: 15,
              child: Text("ID"),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.uid,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 1,
            ),
            Text("Your ${accountInfo.posts.length} Posts"),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * 0.6,
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  postHideIcon == Icons.keyboard_arrow_down
                      ? postHideIcon = Icons.keyboard_arrow_right
                      : postHideIcon = Icons.keyboard_arrow_down;
                });
              },
              icon: Icon(
                postHideIcon,
                size: 34,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 1,
            ),
            Text("You are following ${accountInfo.followers.length}"),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * 0.55,
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  fllowersHideIcon == Icons.keyboard_arrow_down
                      ? fllowersHideIcon = Icons.keyboard_arrow_right
                      : fllowersHideIcon = Icons.keyboard_arrow_down;
                });
              },
              icon: Icon(
                fllowersHideIcon,
                size: 34,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
