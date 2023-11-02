import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tpi_programming_club/app/core/image_picker.dart';
import 'package:tpi_programming_club/app/core/show_toast_meassage.dart';
import 'package:tpi_programming_club/app/views/pages/create_post/quill_editor/code/edit_code.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_highlight/themes/monokai-sublime.dart';
// ignore: depend_on_referenced_packages
import 'package:highlight/languages/all.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../themes/const_theme_data.dart';

class MyQuillEditor extends StatefulWidget {
  const MyQuillEditor({super.key, required this.name, required this.id});

  final String name;
  final String id;

  @override
  State<MyQuillEditor> createState() => _MyQuillEditorState();
}

class _MyQuillEditorState extends State<MyQuillEditor> {
  final QuillController quillEditorController = QuillController.basic();

  List<Map<String, dynamic>> postData = [];
  List<Widget> postPreview = [];

  late List<dynamic> currentQuillControllerData;

  void deletePartOfPost(int index) {
    postData.removeAt(index);
    postPreview = createWidget(postData);
    setState(() {
      postData;
    });
  }

  void editQuillPartOfPost(int index) {
    final temQuillController = QuillController(
        document: Document.fromJson(postData[index]['data']),
        selection: const TextSelection(baseOffset: 0, extentOffset: 0));
    showCupertinoModalPopup(
      barrierColor: Colors.black,
      context: context,
      builder: (context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: QuillProvider(
              configurations:
                  QuillConfigurations(controller: temQuillController),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          postData[index] = {
                            "type": "quill",
                            "data":
                                temQuillController.document.toDelta().toJson()
                          };
                          postPreview = createWidget(postData);
                          setState(() {
                            postData;
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.done),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(child: QuillEditor.basic()),
                  const QuillToolbar()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void moveUp(int index) {
    if (index > 0) {
      var tem = postData[index - 1];
      postData[index - 1] = postData[index];
      postData[index] = tem;
    }
    postPreview = createWidget(postData);
    setState(() {
      postData;
    });
  }

  void moveDown(int index) {
    if (index < postData.length - 1) {
      var tem = postData[index + 1];
      postData[index + 1] = postData[index];
      postData[index] = tem;
    }
    postPreview = createWidget(postData);
    setState(() {
      postData;
    });
  }

  void addQuillDataToPost(List<dynamic> data) {
    Map<String, dynamic> partOfPostData = {
      "type": "quill",
      "data": data,
    };
    postData.add(partOfPostData);
    postPreview = createWidget(postData);
    setState(() {
      postPreview;
    });
  }

  List<Widget> createWidget(List<Map<String, dynamic>> data) {
    List<Widget> widgetList = [];
    for (var i = 0; i < data.length; i++) {
      final partOfData = data[i];

      if (partOfData['type'] == 'quill') {
        final quillData = partOfData['data'];
        Widget partOfPost = Row(
          children: [
            QuillProvider(
              configurations: QuillConfigurations(
                controller: QuillController(
                  document: Document.fromJson(quillData),
                  selection:
                      const TextSelection(baseOffset: 0, extentOffset: 0),
                ),
              ),
              child: Expanded(
                child: QuillEditor.basic(
                  configurations: const QuillEditorConfigurations(
                    readOnly: true,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(99, 72, 202, 76),
              ),
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () => editQuillPartOfPost(i),
                    child: const Row(children: [
                      Icon(Icons.edit),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Edit"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => deletePartOfPost(i),
                    child: const Row(children: [
                      Icon(Icons.delete),
                      SizedBox(
                        width: 2,
                      ),
                      Text("delete"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => moveUp(i),
                    child: const Row(children: [
                      Icon(Icons.arrow_upward),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Move Up"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => moveDown(i),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_downward),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Move down"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        widgetList.add(partOfPost);
      } else if (partOfData['type'] == 'code') {
        var codeThemeStyle = monokaiSublimeTheme;
        CodeController codeController = CodeController(
          text: partOfData['data']['code'],
          patternMap: {
            r"\B#[a-zA-Z0-9]+\b": const TextStyle(color: Colors.red),
            r"\B@[a-zA-Z0-9]+\b": const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.blue,
            ),
            r"\B![a-zA-Z0-9]+\b": const TextStyle(
                color: Colors.yellow, fontStyle: FontStyle.italic),
          },
          stringMap: {
            "bev": const TextStyle(color: Colors.indigo),
          },
          language: allLanguages[partOfData['data']['language']],
        );

        Widget codeWidget = Row(
          children: [
            Expanded(
              child: CodeTheme(
                data: CodeThemeData(styles: codeThemeStyle),
                child: CodeField(
                  controller: codeController,
                  textStyle: GoogleFonts.firaMono(
                      color: Colors.white,
                      textStyle: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(99, 72, 202, 76),
              ),
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () async {
                      final result = await Get.to(
                        () => AddCodeToPost(
                          language: partOfData['data']['language'],
                          codeText: partOfData['data']['code'],
                        ),
                      );
                      if (result != null) {
                        final codeData = {
                          "data": result,
                          "type": "code",
                        };
                        postData[i] = codeData;
                        setState(() {
                          postData;
                        });
                        postPreview = createWidget(postData);
                        setState(() {
                          postPreview;
                        });
                      }
                    },
                    child: const Row(children: [
                      Icon(Icons.edit),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Edit"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => deletePartOfPost(i),
                    child: const Row(children: [
                      Icon(Icons.delete),
                      SizedBox(
                        width: 2,
                      ),
                      Text("delete"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => moveUp(i),
                    child: const Row(children: [
                      Icon(Icons.arrow_upward),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Move Up"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => moveDown(i),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_downward),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Move down"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        widgetList.add(codeWidget);
      } else if (partOfData['type'] == "img") {
        Widget imgWidget = Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(80, 113, 113, 113),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: partOfData['data'],
                  fit: BoxFit.scaleDown,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(99, 72, 202, 76),
              ),
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () => deletePartOfPost(i),
                    child: const Row(children: [
                      Icon(Icons.delete),
                      SizedBox(
                        width: 2,
                      ),
                      Text("delete"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => moveUp(i),
                    child: const Row(children: [
                      Icon(Icons.arrow_upward),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Move Up"),
                    ]),
                  ),
                  PopupMenuItem(
                    onTap: () => moveDown(i),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_downward),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Move down"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        widgetList.add(imgWidget);
      } else if (partOfData['type'] == 'youtube') {
        String url = partOfData['data'];
        String? videoID = YoutubePlayer.convertUrlToId(url);
        if (videoID != null) {
          YoutubePlayerController controller = YoutubePlayerController(
            initialVideoId: videoID,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              hideControls: false,
            ),
          );

          Widget youtubeWidget = Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
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
              ),
              Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(99, 72, 202, 76),
                ),
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => deletePartOfPost(i),
                      child: const Row(children: [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 2,
                        ),
                        Text("delete"),
                      ]),
                    ),
                    PopupMenuItem(
                      onTap: () => moveUp(i),
                      child: const Row(children: [
                        Icon(Icons.arrow_upward),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Move Up"),
                      ]),
                    ),
                    PopupMenuItem(
                      onTap: () => moveDown(i),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_downward),
                          SizedBox(
                            width: 2,
                          ),
                          Text("Move down"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          widgetList.add(youtubeWidget);
        }
      }
    }
    return widgetList;
  }

  void addImageDataToPost() {}
  void addCodeToPost() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  PickPhotoFileWithUrlMobile imgData =
                      await pickPhotoMobile("contents/${widget.id}/");
                  if (imgData.url != null) {
                    final data = {
                      "type": "img",
                      "data": imgData.url,
                    };
                    postData.add(data);
                    setState(() {
                      postData;
                    });
                    postPreview = createWidget(postData);
                    setState(() {
                      postPreview;
                    });
                  }
                },
                child: const Row(children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(
                    width: 4,
                  ),
                  Text("Add Image"),
                ]),
              ),
              PopupMenuItem(
                onTap: () async {
                  final result = await Get.to(
                    () => const AddCodeToPost(
                      language: "language",
                      codeText: "",
                    ),
                  );
                  if (result != null) {
                    final codeData = {
                      "data": result,
                      "type": "code",
                    };
                    postData.add(codeData);
                    setState(() {
                      postData;
                    });
                    postPreview = createWidget(postData);
                    setState(() {
                      postPreview;
                    });
                  } else {
                    showToast("Nothing is found");
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.code),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Add Code"),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  TextEditingController inputController =
                      TextEditingController();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value!.length > 5) {
                                  return null;
                                } else {
                                  return "Your email is not correct...";
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: ConstantThemeData()
                                    .onFocusOutlineInputBorder,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(width: 3),
                                ),
                                labelText: "Youtube Link",
                                hintText:
                                    "Type your youtube video link here...",
                              ),
                              controller: inputController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  http.Response urlResponse = await http.head(
                                    Uri.parse(inputController.text),
                                  );
                                  if (urlResponse.statusCode == 200) {
                                    final data = {
                                      "type": "youtube",
                                      "data": inputController.text,
                                    };
                                    postData.add(data);
                                    setState(() {
                                      postData;
                                    });
                                    postPreview = createWidget(postData);
                                    setState(() {
                                      postPreview;
                                    });
                                  } else {
                                    showToast("Doesn't exits");
                                  }
                                } catch (e) {
                                  showToast(e.toString());
                                }
                              },
                              icon: const Icon(Icons.done),
                              label: const Text("ok"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.video_collection_outlined),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Youtube Video"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: QuillProvider(
        configurations: QuillConfigurations(controller: quillEditorController),
        child: ListView(
          reverse: true,
          children: [
            QuillToolbar(
              configurations: QuillToolbarConfigurations(
                customButtons: [
                  QuillCustomButton(
                    child: const Icon(Icons.add),
                    tooltip: "Add this data to post",
                    onTap: () {
                      addQuillDataToPost(
                        quillEditorController.document.toDelta().toJson(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.all(2),
              padding:
                  const EdgeInsets.only(top: 10, left: 2, right: 2, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(80, 116, 116, 116)),
              child: QuillEditor.basic(
                configurations: const QuillEditorConfigurations(
                  readOnly: false,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(80, 116, 116, 116)),
              child: Column(
                children: postPreview,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
