// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';

import 'package:rive/rive.dart' hide Image;

import 'src/theme/break_point.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String validEmail = "Dandi@gmail.com";
  String validPassword = "12345";

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
          Expanded(
            flex: 2,
            child: breakPoint < window.width
                ? Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
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
            child: Container(
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
                    const Gap(20),
                    const Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 300,
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
                              child: TextField(
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Full Name",
                                ),
                                obscureText: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {},
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
                              child: TextField(
                                focusNode: emailFocusNode,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {
                                  numLook?.change(value.length.toDouble());
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
                              child: TextField(
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                ),
                                obscureText: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {},
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
                              child: TextField(
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                ),
                                obscureText: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {},
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
                              child: TextField(
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                ),
                                obscureText: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 64,
                              child: ElevatedButton(
                                onPressed: () async {
                                  emailFocusNode.unfocus();
                                  passwordFocusNode.unfocus();

                                  final email = emailController.text;
                                  final password = passwordController.text;

                                  showDialog(
                                    context: context,
                                    builder: (context) => const Dialog(
                                      child: Center(
                                        child: CircularProgressIndicator(),
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
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text("Login"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
