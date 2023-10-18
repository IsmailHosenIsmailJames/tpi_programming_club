import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpi_programming_club/app/themes/const_theme_data.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

import 'post_output_markdown.dart';

class PostEditor extends StatefulWidget {
  const PostEditor({super.key, required this.name, required this.id});
  final String name;
  final String id;

  @override
  State<PostEditor> createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  TextEditingController editorController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Markdown"),
      ),
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            reverse: true,
            children: [
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_fromKey.currentState!.validate()) {
                        Get.to(
                          () => MarkDownOutPut(
                            markdown: editorController.text,
                            name: widget.name,
                            id: widget.id,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: ConstantThemeData().primaryColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Icon(Icons.forward),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Form(
                key: _fromKey,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.firaMono(
                      textStyle: Theme.of(context).textTheme.bodyLarge),
                  controller: editorController,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return "Can't be empty...";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Markdown",
                    labelStyle: TextStyle(
                        color: ConstantThemeData().primaryColour,
                        fontWeight: FontWeight.bold),
                    hintText: "Put your markdown text here...",
                    focusedBorder:
                        ConstantThemeData().onFocusOutlineInputBorder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
