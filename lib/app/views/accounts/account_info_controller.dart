import 'package:get/get.dart';

class AccountInfoController extends GetxController {
  RxString name = "UserName".obs;
  RxString email = 'user@email.com'.obs;
  RxString img = 'null'.obs;
  RxList posts = <dynamic>[].obs;
  RxList followers = <dynamic>[].obs;
  RxBool allowMessages = false.obs;
}
