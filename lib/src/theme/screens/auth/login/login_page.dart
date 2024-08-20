import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tpi_programming_club/src/theme/screens/auth/signup/sign_up_page.dart';

import '../../../break_point.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String validEmail = "mail@mail.com";
  String validPassword = "1234567890";

  DateTime? dateOfBirth;

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  TextStyle textStyleForField = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.grey.shade800,
  );

  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: breakPoint < window.width
          ? const Color.fromARGB(255, 1, 53, 131)
          : const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: Row(
        children: [
          if (breakPoint < window.width)
            Expanded(
              flex: 2,
              child: breakPoint < window.width
                  ? Container(
                      padding:
                          const EdgeInsets.only(left: 40, right: 20, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          const Text(
                            "Be with us\nfor better community\nand better future.",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(30),
                          const Text(
                            "Be with",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "TPI Programming Club",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue.shade300,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("assets/img/logo.jpeg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const Gap(20),
                          const Text(
                            "TPI Programming Club",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          Expanded(
            flex: 3,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(10),
                height: window.height,
                decoration: breakPoint < window.width
                    ? const BoxDecoration(
                        color: Color(0xFFD6E2EA),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40)))
                    : null,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 280,
                        width: 300,
                        child: RiveAnimation.asset(
                          "assets/animations/animated_login_character.riv",
                          fit: BoxFit.fitHeight,
                          stateMachines: const ["Login Machine"],
                          onInit: (artboard) {
                            controller = StateMachineController.fromArtboard(
                              artboard,

                              /// from rive, you can see it in rive editor
                              "Login Machine",
                            );
                            if (controller == null) return;

                            artboard.addController(controller!);
                            isChecking = controller?.findInput("isChecking");
                            numLook = controller?.findInput("numLook");
                            isHandsUp = controller?.findInput("isHandsUp");
                            trigSuccess = controller?.findInput("trigSuccess");
                            trigFail = controller?.findInput("trigFail");
                          },
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (EmailValidator.validate(
                                          value ?? "")) {
                                        trigSuccess?.change(true);
                                        return null;
                                      } else {
                                        return "Email is not valid";
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    focusNode: emailFocusNode,
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                    ),
                                    style: textStyleForField,
                                    onChanged: (value) {
                                      numLook
                                          ?.change(value.length.toDouble() * 2);
                                    },
                                  ),
                                ),
                                const Gap(10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if ((value ?? "").length >= 8) {
                                        return null;
                                      } else {
                                        return "Password is short";
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    focusNode: passwordFocusNode,
                                    controller: passwordController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                    ),
                                    obscureText: true,
                                    style: textStyleForField,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 64,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (isSignUp &&
                                          formKey.currentState!.validate()) {
                                        emailFocusNode.unfocus();
                                        passwordFocusNode.unfocus();

                                        final email = emailController.text;
                                        final password =
                                            passwordController.text;

                                        showDialog(
                                          context: context,
                                          builder: (context) => const Dialog(
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        );
                                        await Future.delayed(
                                          const Duration(milliseconds: 2000),
                                        );
                                        if (mounted) Navigator.pop(context);

                                        if (email == validEmail &&
                                            password == validPassword) {
                                          trigSuccess?.change(true);
                                        } else {
                                          trigFail?.change(true);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Haven't any account?",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Gap(10),
                                    TextButton(
                                      onPressed: () {
                                        Get.off(
                                          () => const SignUpPage(),
                                        );
                                      },
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
