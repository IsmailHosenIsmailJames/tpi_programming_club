import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/views/accounts/login_widget_controller.dart';

import '../../../themes/const_theme_data.dart';
import '../../../themes/app_theme_data.dart';
import '../init.dart';
import '../signin/signin.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final validationKey = GlobalKey<FormState>();
  final AccountWidgetController accountGetController =
      Get.put(AccountWidgetController());

  Future<UserCredential> signInWithGoogleAndroid() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
  }

  void logIn() async {
    if (validationKey.currentState!.validate()) {
      accountGetController.signUp.value = Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blue, size: 40),
      );
      // TO DO : login on firebase
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text);
        Get.offAll(() => const InIt());
        accountGetController.login.value = const Center(
          child: Icon(Icons.done),
        );
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message!,
          fontSize: 16,
          textColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
        );
      }
      accountGetController.login.value = const Center(
        child: Text(
          "LogIn failed, try again",
          style: TextStyle(fontSize: 20, color: Colors.deepOrange),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 340,
            decoration: BoxDecoration(
              color: const Color.fromARGB(50, 150, 150, 150),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: ConstantThemeData().primaryColour,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: ConstantThemeData().primaryColour,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      height: 50,
                      width: 50,
                      child: GetX<AppThemeData>(
                        builder: (controller) => IconButton(
                          onPressed: () {
                            if (controller.themeModeName.value == 'system') {
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
                    right: 10,
                    left: 10,
                    bottom: 30,
                  ),
                  child: Form(
                    key: validationKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          validator: (value) {
                            if (EmailValidator.validate(value!)) {
                              return null;
                            } else {
                              return "Your email is not correct...";
                            }
                          },
                          controller: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            focusedBorder:
                                ConstantThemeData().onFocusOutlineInputBorder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(width: 3),
                            ),
                            labelText: "Email",
                            hintText: "Type your email here...",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onEditingComplete: () {
                            logIn();
                          },
                          validator: (value) {
                            if (value!.length >= 8) {
                              return null;
                            } else {
                              return "Password leangth should be at least 8...";
                            }
                          },
                          controller: password,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                            focusedBorder:
                                ConstantThemeData().onFocusOutlineInputBorder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Password",
                            hintText: "Type your password here...",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              maximumSize: const Size(380, 50),
                              minimumSize: const Size(380, 50),
                              backgroundColor:
                                  ConstantThemeData().primaryColour,
                            ),
                            onPressed: () {
                              logIn();
                            },
                            child: accountGetController.login.value,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            maximumSize: const Size(380, 50),
                            minimumSize: const Size(380, 50),
                            backgroundColor:
                                const Color.fromARGB(80, 158, 158, 158),
                          ),
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                            if (kIsWeb) {
                              final result = await signInWithGoogleWeb();
                              if (kDebugMode) {
                                print(result.user!.email);
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else {
                              final result = await signInWithGoogleAndroid();
                              if (kDebugMode) {
                                print(result.user!.email);
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(FontAwesomeIcons.google),
                          label: const Text("Signin With Google"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Haven't account?"),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const SignIn());
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantThemeData().primaryColour,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
