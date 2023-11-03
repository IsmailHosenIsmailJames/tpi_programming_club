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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CreatePostViewQuill {
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
        String? videoID = YoutubePlayer.convertUrlToId(url);
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
    return QuillProvider(
      configurations: QuillConfigurations(
        controller: QuillController(
          document: Document.fromJson(quillData),
          selection: const TextSelection(baseOffset: 0, extentOffset: 0),
        ),
      ),
      child: Expanded(
        child: QuillEditor.basic(
          configurations: const QuillEditorConfigurations(
            readOnly: true,
          ),
        ),
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

    return Expanded(
      child: CodeTheme(
        data: CodeThemeData(styles: codeThemeStyle),
        child: CodeField(
          readOnly: true,
          controller: codeController,
          textStyle: GoogleFonts.firaMono(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget addYoutubeVideoWidget(String videoID, int i) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideControls: false,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(80, 113, 113, 113),
      ),
      child: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressColors: const ProgressBarColors(
          playedColor: Colors.blue,
          handleColor: Colors.green,
        ),
      ),
    );
  }
}
