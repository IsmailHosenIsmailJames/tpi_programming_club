import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../themes/app_theme_data.dart';
import '../../../themes/const_theme_data.dart';
import '../init.dart';
import '../login/login.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final signUpValidationKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final name = TextEditingController();
  final confirmPass = TextEditingController();
  final password = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode confirmFocusNode = FocusNode();

  void signUp() async {
    if (signUpValidationKey.currentState!.validate()) {
      // TO DO : sign in with email and password and store data on firestore
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text);
        await FirebaseDatabase.instance
            .ref(
                '/userData/name/${email.text.replaceAll('.', ",").replaceAll("@", "")}/')
            .set(name.text);
        Get.offAll(const InIt());
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message!,
          fontSize: 16,
          textColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
        );
      }
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
                      "Sign Up",
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
                    key: signUpValidationKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(emailFocusNode);
                          },
                          validator: (value) {
                            if (value!.length >= 3) {
                              return null;
                            } else {
                              return "আপনার নামটি সঠিক নয় ...";
                            }
                          },
                          controller: name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            focusedBorder:
                                ConstantThemeData().onFocusOutlineInputBorder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(width: 3),
                            ),
                            labelText: "Name",
                            hintText: "আপনার নামটি এখানে লিখুন ...",
                          ),
                        ),
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
                              return "আপনার ইমেইলটি সঠিক নয় ...";
                            }
                          },
                          focusNode: emailFocusNode,
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
                            hintText: "আপনার ইমেইলটি এখানে লিখুন ...",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(confirmFocusNode);
                          },
                          validator: (value) {
                            if (value!.length >= 8) {
                              return null;
                            } else {
                              return "পাসওয়ার্ড সর্বনিম্ন ৮ সংখ্যার হতে হবে ...";
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
                              borderSide: const BorderSide(width: 3),
                            ),
                            labelText: "Password",
                            hintText: "আপনার পাসওয়ার্ড এখানে লিখুন ...",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onEditingComplete: () {
                            signUp();
                          },
                          validator: (value) {
                            if (password.text == confirmPass.text &&
                                password.text != "") {
                              return null;
                            } else {
                              return "পাসওয়ার্ড সর্বনিম্ন ৮ সংখ্যার হতে হবে ...";
                            }
                          },
                          controller: confirmPass,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          focusNode: confirmFocusNode,
                          decoration: InputDecoration(
                            focusedBorder:
                                ConstantThemeData().onFocusOutlineInputBorder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(width: 3),
                            ),
                            labelText: "Confirm Password",
                            hintText: "আপনার পাসওয়ার্ড এখানে লিখুন ...",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            maximumSize: const Size(380, 50),
                            minimumSize: const Size(380, 50),
                            backgroundColor: ConstantThemeData().primaryColour,
                          ),
                          onPressed: () {
                            signUp();
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Have already an account?"),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const LogIn());
                              },
                              child: Text(
                                "Login",
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
