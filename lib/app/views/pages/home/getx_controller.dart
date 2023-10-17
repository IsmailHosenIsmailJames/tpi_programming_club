import 'package:get/get.dart';

class HomeGetController extends GetxController {
  RxString pageName = "Home".obs;

  void changePageName(String name) {
    pageName.value = name;
  }
}
