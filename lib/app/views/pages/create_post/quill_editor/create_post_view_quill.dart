import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_highlight/themes/monokai-sublime.dart';
// ignore: depend_on_referenced_packages
import 'package:highlight/languages/all.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CreatePostViewQuill {
  List<Widget> createWidgetFromString(String data) {
    List<Map<String, dynamic>> listOfMap = [];
    List decodedData = jsonDecode(data);
    for (var element in decodedData) {
      listOfMap.add(Map<String, dynamic>.from(element));
    }

    return createWidget(listOfMap);
  }

  static String? convertYoytubeVideoUrlToId(String url,
      {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  List<Widget> createWidget(List<Map<String, dynamic>> data) {
    List<Widget> widgetList = [];
    for (var i = 0; i < data.length; i++) {
      final partOfData = data[i];
      if (partOfData['type'] == 'quill') {
        Widget partOfPost = addQuillWidgetDataToPost(partOfData, i);
        widgetList.add(partOfPost);
      } else if (partOfData['type'] == 'code') {
        Widget codeWidget = addCodeWidgetToPost(partOfData, i);
        widgetList.add(codeWidget);
      } else if (partOfData['type'] == "img") {
        Widget imgWidget = addImageDataToPost(partOfData, i);
        widgetList.add(imgWidget);
      } else if (partOfData['type'] == 'youtube') {
        String url = partOfData['data'];
        String? videoID = convertYoytubeVideoUrlToId(url);
        if (videoID != null) {
          Widget youtubeWidget = addYoutubeVideoWidget(videoID, i);
          widgetList.add(youtubeWidget);
        }
      }
    }
    return widgetList;
  }

  Widget addQuillWidgetDataToPost(Map<String, dynamic> partOfData, int i) {
    final quillData = partOfData['data'];
    return QuillEditor(
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      configurations: QuillEditorConfigurations(
        readOnly: true,
        controller: QuillController(
          document: Document.fromJson(quillData),
          selection: const TextSelection(baseOffset: 0, extentOffset: 0),
        ),
      ).copyWith(
        elementOptions: const QuillEditorElementOptions(
          codeBlock: QuillEditorCodeBlockElementOptions(
            enableLineNumbers: true,
          ),
          orderedList: QuillEditorOrderedListElementOptions(
            customWidget: Icon(Icons.add),
          ),
          unorderedList: QuillEditorUnOrderedListElementOptions(
            useTextColorForDot: true,
          ),
        ),
        customStyles: const DefaultStyles(
          h1: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 32,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            VerticalSpacing(16, 0),
            VerticalSpacing(0, 0),
            null,
          ),
          sizeSmall: TextStyle(fontSize: 9),
          subscript: TextStyle(
            fontFamily: 'SF-UI-Display',
            fontFeatures: [FontFeature.subscripts()],
          ),
          superscript: TextStyle(
            fontFamily: 'SF-UI-Display',
            fontFeatures: [FontFeature.superscripts()],
          ),
        ),
        scrollable: true,
        placeholder: 'Start writting your post...',
      ),
    );
  }

  Widget addImageDataToPost(Map<String, dynamic> partOfData, int i) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(80, 113, 113, 113),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: partOfData['data'],
          fit: BoxFit.scaleDown,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 40,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget addCodeWidgetToPost(Map<String, dynamic> partOfData, int i) {
    var codeThemeStyle = monokaiSublimeTheme;
    CodeController codeController = CodeController(
      text: partOfData['data']['code'],
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
      language: allLanguages[partOfData['data']['language']],
    );

    return CodeTheme(
      data: CodeThemeData(styles: codeThemeStyle),
      child: CodeField(
        readOnly: true,
        controller: codeController,
        textStyle: GoogleFonts.firaMono(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget addYoutubeVideoWidget(String videoID, int i) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 410,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(80, 113, 113, 113),
      ),
      child: Expanded(
        child: MarkdownWidget(
          data:
              """[![https://www.youtube.com/watch?v=$videoID](https://img.youtube.com/vi/$videoID/0.jpg)](https://www.youtube.com/watch?v=$videoID)
        **Click here to watch the video!**""",
        ),
      ),
    );
  }
}
