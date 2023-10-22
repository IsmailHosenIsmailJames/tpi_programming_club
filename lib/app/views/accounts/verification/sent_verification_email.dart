import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/show_toast_meassage.dart';

Future<bool> sentValidationEmail() async {
  try {
    await FirebaseAuth.instance.currentUser!
        .sendEmailVerification(ActionCodeSettings(
      url:
          'https://developersunited.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
    ));
    return true;
  } on FirebaseAuthException catch (e) {
    showToast(e.message!);
    return false;
  }
}
