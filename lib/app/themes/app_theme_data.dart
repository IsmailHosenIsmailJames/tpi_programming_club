import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tpi_programming_club/app/themes/const_theme_data.dart';

class AppThemeData extends GetxController {
  RxString themeModeName = 'system'.obs;
  Rx<IconData> themeIcon = Icons.brightness_6.obs;
  Rx<Color> drawerAppBarColor = ConstantThemeData().drawerAppBarLightColor.obs;
  Rx<Color> navbarColor = ConstantThemeData().navbarColorLight.obs;

  void initTheme() {
    var box = Hive.box('tpi_programming_club');
    var userTheme = box.get('theme_preference', defaultValue: false);
    if (userTheme != false) {
      if (userTheme == 'light') {
        Get.changeThemeMode(ThemeMode.light);
        themeModeName.value = 'light';
        themeIcon.value = Icons.sunny;
        drawerAppBarColor.value = ConstantThemeData().drawerAppBarLightColor;
        navbarColor.value = ConstantThemeData().navbarColorLight;
      } else if (userTheme == 'dark') {
        Get.changeThemeMode(ThemeMode.dark);
        themeModeName.value = 'dark';
        themeIcon.value = Icons.brightness_2;
        drawerAppBarColor.value = ConstantThemeData().drawerAppBarDarkColor;
        navbarColor.value = ConstantThemeData().navbarColorDark;
      } else if (userTheme == 'system') {
        Get.changeThemeMode(ThemeMode.system);
        themeModeName.value = 'system';
        themeIcon.value = Icons.brightness_6;
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? {
                drawerAppBarColor.value =
                    ConstantThemeData().drawerAppBarDarkColor,
                navbarColor.value = ConstantThemeData().navbarColorDark,
              }
            : {
                drawerAppBarColor.value =
                    ConstantThemeData().drawerAppBarLightColor,
                navbarColor.value = ConstantThemeData().navbarColorLight,
              };
      }
    } else {
      box.put('theme_preference', 'system');
    }
  }

  void setTheme(String themeToChange) {
    var box = Hive.box('tpi_programming_club');
    if (themeToChange == 'light') {
      Get.changeThemeMode(ThemeMode.light);
      box.put('theme_preference', 'light');
      themeModeName.value = 'light';
      themeIcon.value = Icons.sunny;
      drawerAppBarColor.value = ConstantThemeData().drawerAppBarLightColor;
      navbarColor.value = ConstantThemeData().navbarColorLight;
    } else if (themeToChange == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
      box.put('theme_preference', 'dark');
      themeModeName.value = 'dark';
      themeIcon.value = Icons.brightness_2;
      drawerAppBarColor.value = ConstantThemeData().drawerAppBarDarkColor;
      navbarColor.value = ConstantThemeData().navbarColorDark;
    } else if (themeToChange == 'system') {
      Get.changeThemeMode(ThemeMode.system);
      box.put('theme_preference', 'system');
      themeModeName.value = 'system';
      themeIcon.value = Icons.brightness_6;
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark
          ? {
              drawerAppBarColor.value =
                  ConstantThemeData().drawerAppBarDarkColor,
              navbarColor.value = ConstantThemeData().navbarColorDark,
            }
          : {
              drawerAppBarColor.value =
                  ConstantThemeData().drawerAppBarLightColor,
              navbarColor.value = ConstantThemeData().navbarColorLight,
            };
    }
  }
}
