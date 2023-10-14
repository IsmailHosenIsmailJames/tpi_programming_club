import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tpi_programming_club/app/views/accounts/login/login.dart';
import 'package:tpi_programming_club/app/views/accounts/signin/signin.dart';
import 'package:tpi_programming_club/app/views/home/home.dart';

class ButtomNavigationBar extends StatefulWidget {
  const ButtomNavigationBar({super.key});

  @override
  State<ButtomNavigationBar> createState() => DemoPageState();
}

class DemoPageState extends State<ButtomNavigationBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final List<PersistentBottomNavBarItem> _navBarsItems = [
    PersistentBottomNavBarItem(icon: const Icon(Icons.home), title: "Home"),
    PersistentBottomNavBarItem(icon: const Icon(Icons.logo_dev), title: "DEV"),
    PersistentBottomNavBarItem(icon: const Icon(Icons.abc), title: "ABC"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salomon Battom Bar"),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        margin: const EdgeInsets.all(10),
        screens: const [HomePage(), LogIn(), SignIn()],
        items: _navBarsItems,
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 10.0,
              offset: Offset(0.0, 0.75),
            ),
          ],
          borderRadius: BorderRadius.circular(100),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOutQuint,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
      // bottomNavigationBar: SalomonBottomBar(
      //   backgroundColor: Colors.green,
      //   currentIndex: _currentIndex,
      //   onTap: (i) => setState(() => _currentIndex = i),
      //   items: [
      //     /// Home
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.home),
      //       title: const Text("Home"),
      //       selectedColor: Colors.purple,
      //     ),

      //     /// Likes
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.favorite_border),
      //       title: const Text("Likes"),
      //       selectedColor: Colors.pink,
      //     ),

      //     /// Search
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.search),
      //       title: const Text("Search"),
      //       selectedColor: Colors.orange,
      //     ),

      //     /// Profile
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.person),
      //       title: const Text("Profile"),
      //       selectedColor: Colors.teal,
      //     ),
      //   ],
      // ),
    );
  }
}
