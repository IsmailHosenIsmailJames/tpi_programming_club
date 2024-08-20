import 'package:bottom_picker/bottom_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tpi_programming_club/src/theme/screens/auth/login/login_page.dart';

import '../../../break_point.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String validEmail = "mail@mail.com";
  String validPassword = "1234567890";

  DateTime? dateOfBirth;

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  TextEditingController fullNameController = TextEditingController();

  FocusNode boardRollFocusNode = FocusNode();
  TextEditingController boardRollController = TextEditingController();

  FocusNode sessionFocusNode = FocusNode();
  TextEditingController sessionController = TextEditingController();

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
    boardRollFocusNode.addListener(rollFocus);
    fullNameFocusNode.addListener(fullNameFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    boardRollFocusNode.removeListener(rollFocus);
    fullNameFocusNode.removeListener(fullNameFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void rollFocus() {
    isChecking?.change(boardRollFocusNode.hasFocus);
  }

  void fullNameFocus() {
    isChecking?.change(fullNameFocusNode.hasFocus);
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
  bool isValidationCheaked = false;

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
                        "Create your account",
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
                                      if (value == null || value.length < 3) {
                                        return "Name is too short";
                                      } else {
                                        return null;
                                      }
                                    },
                                    focusNode: fullNameFocusNode,
                                    controller: fullNameController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Full Name",
                                    ),
                                    style: textStyleForField,
                                    onChanged: (value) {
                                      numLook
                                          ?.change(value.length.toDouble() * 2);
                                    },
                                  ),
                                ),
                                const Gap(10),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return BottomPicker.date(
                                          pickerTitle: const Text(
                                            "Date of Birth",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          initialDateTime: DateTime(2004),
                                          onSubmit: (p0) {
                                            setState(() {
                                              dateOfBirth = p0;
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 65,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: dateOfBirth == null
                                        ? Text(
                                            "Date of Birth",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: isValidationCheaked
                                                  ? Colors.red.shade400
                                                  : null,
                                            ),
                                          )
                                        : Text(
                                            dateOfBirth!
                                                .toIso8601String()
                                                .split("T")[0],
                                            style: textStyleForField),
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
                                      int? x = int.tryParse(value.toString());
                                      if (x == null ||
                                          value!.length > 6 ||
                                          value.length < 6) {
                                        if (value!.length > 6) {
                                          trigFail?.change(true);
                                        }
                                        return "Roll is not correct";
                                      } else {
                                        if (value.length == 6) {
                                          trigSuccess?.change(true);
                                        }
                                        return null;
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    focusNode: boardRollFocusNode,
                                    controller: boardRollController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Board Roll",
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
                                      } else {
                                        if (!formKey.currentState!.validate()) {
                                          setState(() {
                                            isValidationCheaked = true;
                                          });
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
                                      "Signn Up",
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
                                      "Already have an account?",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Gap(10),
                                    TextButton(
                                      onPressed: () {
                                        Get.off(
                                          () => const LoginPage(),
                                        );
                                      },
                                      child: const Text(
                                        "Login",
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
