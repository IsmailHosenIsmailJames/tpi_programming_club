import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart';
import 'package:tpi_programming_club/app/views/accounts/init.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/quill_editor/quill_editor.dart';

import 'app/themes/app_theme_data.dart';
import 'app/views/pages/home/getx_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  await Hive.initFlutter();
  await Hive.openBox('tpi_programming_club');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        DefaultCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'TPI Programming Club',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onInit: () {
        var controller = Get.put(AppThemeData());
        Get.put(HomeGetController());
        controller.initTheme();
      },
      home: const MyQuillEditor(name: "", id: ""),
    );
  }
}
