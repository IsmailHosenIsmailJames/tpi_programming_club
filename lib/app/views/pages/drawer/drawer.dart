import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/views/accounts/account_info_controller.dart';
import 'package:tpi_programming_club/app/views/pages/home/home.dart';

import '../../../themes/app_theme_data.dart';
import '../create_post/select_topics.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final accountInfoController = Get.put(AccountInfoController());
  final appthemeController = Get.put(AppThemeData());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Obx(
            () => Container(
              color: appthemeController.drawerAppBarColor.value,
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                            left: 25,
                            bottom: 5,
                          ),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.lightGreen,
                            ),
                            child: Center(
                              child: accountInfoController.img.value == 'null'
                                  ? Text(
                                      accountInfoController.name.value
                                          .substring(0, 2),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            accountInfoController.img.value,
                                        fit: BoxFit.scaleDown,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: LoadingAnimationWidget
                                              .staggeredDotsWave(
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
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: GetX<AppThemeData>(
                            builder: (appthemeController) => IconButton(
                              onPressed: () {
                                if (appthemeController.themeModeName.value ==
                                    'system') {
                                  appthemeController.setTheme('dark');
                                } else if (appthemeController
                                        .themeModeName.value ==
                                    'dark') {
                                  appthemeController.setTheme('light');
                                } else if (appthemeController
                                        .themeModeName.value ==
                                    'light') {
                                  appthemeController.setTheme('system');
                                }
                              },
                              icon: Icon(appthemeController.themeIcon.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 10,
                        bottom: 5,
                        top: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accountInfoController.name.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                accountInfoController.email.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView(
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(() => const HomePage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.home_outlined,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.analytics_outlined,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Your Progress",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(const SelectTopics());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.create,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Create a Tutorial",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Admin Panel",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.settings_outlined,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Settings",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.privacy_tip_outlined,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.feedback_outlined,
                          color: appthemeController.iconColors.value,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Feedback",
                          style: TextStyle(
                            color: appthemeController.iconColors.value,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
