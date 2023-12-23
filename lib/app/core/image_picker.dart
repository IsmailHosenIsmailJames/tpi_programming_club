import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class PickPhotoFileWithUrlMobile {
  final String? url;
  final File? imageFile;

  PickPhotoFileWithUrlMobile(this.imageFile, this.url);
}

class PickPhotoFileWithUrlWeb {
  final String? url;
  final Uint8List? imageFile;

  PickPhotoFileWithUrlWeb(this.imageFile, this.url);
}

Future<PickPhotoFileWithUrlMobile> pickPhotoMobile(String toUploadePath) async {
  String? url;
  File? imageFile;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowCompression: true,
    type: FileType.custom,
    allowMultiple: false,
    allowedExtensions: ['jpg', 'png'],
  );
  if (result != null) {
    final tem = result.files.first;
    String? extension = tem.extension;
    imageFile = File(tem.path!);
    String imageName = tem.path!;
    String uploadePath =
        "$toUploadePath${DateTime.now().millisecondsSinceEpoch}$imageName.$extension";
    final ref = FirebaseStorage.instance.ref().child(uploadePath);
    UploadTask uploadTask;
    uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    url = await snapshot.ref.getDownloadURL();
  }
  return PickPhotoFileWithUrlMobile(imageFile, url);
}

Future<PickPhotoFileWithUrlWeb> pickPhotoWeb(String toUploadePath) async {
  String? url = "";
  Uint8List? selectedImage;
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: ['jpg', 'png']);

  if (result != null) {
    final tem = result.files.first;
    selectedImage = tem.bytes;
    String? extension = tem.extension;
    String uploadePath =
        "$toUploadePath${DateTime.now().millisecondsSinceEpoch}.$extension";
    final ref = FirebaseStorage.instance.ref().child(uploadePath);
    UploadTask uploadTask;
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    uploadTask = ref.putData(selectedImage!, metadata);
    final snapshot = await uploadTask.whenComplete(() {});
    url = await snapshot.ref.getDownloadURL();
  }
  return PickPhotoFileWithUrlWeb(selectedImage, url);
}
