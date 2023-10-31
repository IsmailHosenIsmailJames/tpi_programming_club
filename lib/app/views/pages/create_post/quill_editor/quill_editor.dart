import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tpi_programming_club/app/core/image_picker.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

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
  List<Widget> postPrevew = [];

  late List<dynamic> currentQuillControllerData;

  void deletePartOfPost(int index) {
    postData.removeAt(index);
    postPrevew = createWidget(postData);
    setState(() {
      postData;
    });
  }

  void editPartOfPost(int index) {
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
                          postPrevew = createWidget(postData);
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
    postPrevew = createWidget(postData);
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
    postPrevew = createWidget(postData);
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
    postPrevew = createWidget(postData);
    setState(() {
      postPrevew;
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
                    onTap: () => editPartOfPost(i),
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
                onTap: () {
                  pickPhotoMobile("test/");
                },
                child: const Row(children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(
                    width: 4,
                  ),
                  Text("Add Image"),
                ]),
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.code),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Add Code"),
                  ],
                ),
              ),
              const PopupMenuItem(
                child: Row(
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
                children: postPrevew,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
