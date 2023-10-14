import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/app_theme_data.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          GetX<AppThemeData>(
            builder: (controller) => Container(
              color: controller.drawerAppBarColor.value,
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
                            child: const Center(
                              child: Text(
                                "MD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: GetX<AppThemeData>(
                            builder: (controller) => IconButton(
                              onPressed: () {
                                if (controller.themeModeName.value ==
                                    'system') {
                                  controller.setTheme('dark');
                                } else if (controller.themeModeName.value ==
                                    'dark') {
                                  controller.setTheme('light');
                                } else if (controller.themeModeName.value ==
                                    'light') {
                                  controller.setTheme('system');
                                }
                              },
                              icon: Icon(controller.themeIcon.value),
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
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              Text(
                                "useremail@email.com",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_upward,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
