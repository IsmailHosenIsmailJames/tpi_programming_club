import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpi_programming_club/app/themes/const_theme_data.dart';
import 'package:tpi_programming_club/app/views/post_editor_mobile/post_output.dart';

class PostEditor extends StatefulWidget {
  const PostEditor({super.key});

  @override
  State<PostEditor> createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  TextEditingController editorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantThemeData().primaryColour,
        shadowColor: Colors.transparent,
      ),
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
                      Get.to(
                        () => MarkDownOutPut(
                          markdown: editorController.text,
                        ),
                      );
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
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: GoogleFonts.firaMono(
                    textStyle: Theme.of(context).textTheme.bodyLarge),
                controller: editorController,
                decoration: InputDecoration(
                  labelText: "Markdown",
                  labelStyle: TextStyle(
                      color: ConstantThemeData().primaryColour,
                      fontWeight: FontWeight.bold),
                  hintText: "Put your markdown text here...",
                  focusedBorder: ConstantThemeData().onFocusOutlineInputBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
