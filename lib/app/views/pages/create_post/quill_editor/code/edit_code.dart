// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/languages/all.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import '../../../../../core/show_toast_meassage.dart';

class AddCodeToPost extends StatefulWidget {
  const AddCodeToPost(
      {super.key, required this.language, required this.codeText});
  final String language, codeText;

  @override
  State<AddCodeToPost> createState() => _AddCodeToPostState();
}

class _AddCodeToPostState extends State<AddCodeToPost> {
  List<DropdownMenuItem<String>> dropDownItems = [];

  String language = 'language';

  late CodeController _codeController;

  var codeThemeStyle = monokaiSublimeTheme;

  @override
  void initState() {
    super.initState();
    language = widget.language;
    const top = <String>{
      "Language|language",
      "Java|java",
      "C++|cpp",
      "C|cpp",
      "Python|python",
      "JavaScript|javascript",
      "CS|cs",
      "Dart|dart",
      "Haskell|haskell",
      "Ruby|ruby",
      "HTML|htmlbars"
    };
    for (var element in top) {
      dropDownItems.add(
        DropdownMenuItem(
          value: element.split('|')[1],
          child: Text(element.split('|')[0]),
        ),
      );
    }
    _codeController = CodeController(
      text: widget.codeText,
      patternMap: {
        r"\B#[a-zA-Z0-9]+\b": const TextStyle(color: Colors.red),
        r"\B@[a-zA-Z0-9]+\b": const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.blue,
        ),
        r"\B![a-zA-Z0-9]+\b":
            const TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
      },
      stringMap: {
        "bev": const TextStyle(color: Colors.indigo),
      },
      language: allLanguages[widget.language],
    );
  }

  void changeControllerAsLanguage(String languageName, String codeText) {
    CodeController tem = CodeController(
      text: codeText,
      patternMap: {
        r"\B#[a-zA-Z0-9]+\b": const TextStyle(color: Colors.red),
        r"\B@[a-zA-Z0-9]+\b": const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.blue,
        ),
        r"\B![a-zA-Z0-9]+\b":
            const TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
      },
      stringMap: {
        "bev": const TextStyle(color: Colors.indigo),
      },
      language: allLanguages[languageName],
    );

    setState(() {
      _codeController = tem;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = codeThemeStyle;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                CodeTheme(
                  data: CodeThemeData(styles: styles),
                  child: CodeField(
                    controller: _codeController,
                    textStyle: GoogleFonts.firaMono(
                        color: Colors.white,
                        textStyle: Theme.of(context).textTheme.bodyLarge),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 5, top: 5, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(80, 120, 120, 120),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        value: language,
                        items: dropDownItems,
                        onChanged: (newValue) {
                          setState(() {
                            language = newValue!;
                            changeControllerAsLanguage(
                              language,
                              _codeController.text,
                            );
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                        ),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        label: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.done,
                        ),
                        onPressed: () {
                          if (language != 'language') {
                            if (_codeController.text.trim().isEmpty) {
                              showToast("Code is empty");
                              return;
                            } else {
                              final result = {
                                "code": _codeController.text,
                                "language": language
                              };
                              Get.back(result: result);
                            }
                          } else {
                            showToast("Pleage select a language");
                          }
                        },
                        label: const Text(
                          "Ok",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
