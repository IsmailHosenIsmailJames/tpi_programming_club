import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tpi_programming_club/app/themes/app_theme_data.dart';
import 'package:tpi_programming_club/app/views/home/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const HomeDrawer(),
      body: GetX<AppThemeData>(
        builder: (controller) => PersistentTabView(
          context,
          controller: _controller,
          margin: const EdgeInsets.all(5),
          screens: const [
            Center(
              child: Text(
                "Home",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Messages",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Notification",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          items: [
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.home_outlined),
              title: "Home",
            ),
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.message),
              title: "Message",
            ),
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.notifications_active_outlined),
              title: "Notification",
            ),
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.person_outline),
              title: "Profile",
            ),
          ],
          confineInSafeArea: true,
          backgroundColor: controller.navbarColor.value,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutQuint,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style1,
        ),
      ),
    );
  }
}
