import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      File file = File(xfile.path);
      return file;
    }
    return null;
  } catch (e) {
    return null;
  }
}
