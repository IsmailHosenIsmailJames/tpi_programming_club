import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tpi_programming_club/app/data/models/account_model.dart';
import 'package:tpi_programming_club/app/themes/app_theme_data.dart';
import 'package:tpi_programming_club/app/views/accounts/account_info_controller.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';
import 'package:tpi_programming_club/app/views/pages/home/getx_controller.dart';
import 'package:tpi_programming_club/app/views/pages/home/contents/home_content.dart';
import 'package:tpi_programming_club/app/views/pages/messages/messages_page.dart';
import 'package:tpi_programming_club/app/views/pages/notifications/notification_page.dart';
import 'package:tpi_programming_club/app/views/pages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  final homeControllersGet = Get.put(HomeGetController());
  final accountInfoController = Get.put(AccountInfoController());

  Future<void> getAccountInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;
    final allowMessagesData = await FirebaseDatabase.instance
        .ref('/user/${user.uid}/allowMessages')
        .get();
    AccountModel accountModel = AccountModel(
      userName: user.displayName!,
      uid: user.uid,
      userEmail: user.email!,
      allowMessages: allowMessagesData.value == true ? true : false,
      img: user.photoURL == null ? "null" : user.photoURL!,
      posts: [],
      followers: [],
    );
    accountInfoController.name.value = accountModel.userName;
    accountInfoController.email.value = accountModel.userEmail;
    accountInfoController.img.value = accountModel.img;
    accountInfoController.posts.value = accountModel.posts;
    accountInfoController.allowMessages.value = accountModel.allowMessages;
    accountInfoController.followers.value = accountModel.followers;
    var box = Hive.box("tpi_programming_club");
    box.put("userInfo", accountModel.toJson());
  }

  @override
  void initState() {
    getAccountInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<HomeGetController>(
          builder: (controller) => Text(controller.pageName.value),
        ),
      ),
      drawer: const HomeDrawer(),
      body: GetX<AppThemeData>(
        builder: (controller) => PersistentTabView(
          context,
          controller: _controller,
          margin: const EdgeInsets.all(5),
          screens: const [
            HomePageContent(),
            MessagesPage(),
            NotificationPage(),
            ProfilePage(),
          ],
          items: [
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.home_outlined),
              title: "Home",
              onPressed: (p0) {
                _controller.index = 0;
                homeControllersGet.changePageName("Home");
              },
            ),
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.message),
              title: "Messages",
              onPressed: (p0) {
                _controller.index = 1;
                homeControllersGet.changePageName("Messages");
              },
            ),
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.notifications_active_outlined),
              title: "Notification",
              onPressed: (p0) {
                _controller.index = 2;
                homeControllersGet.changePageName("Notifications");
              },
            ),
            PersistentBottomNavBarItem(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              activeColorPrimary: Colors.orange,
              activeColorSecondary: Colors.deepOrange,
              inactiveColorPrimary: Colors.green,
              icon: const Icon(Icons.person_outline),
              title: "Profile",
              onPressed: (p0) {
                _controller.index = 3;
                homeControllersGet.changePageName("Profile");
              },
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
