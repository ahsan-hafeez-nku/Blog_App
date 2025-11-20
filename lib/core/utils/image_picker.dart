import 'dart:io';

import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<File?> pickImage({required ImageSource source}) async {
  try {
    final xfile = await _picker.pickImage(source: source);
    return xfile != null ? File(xfile.path) : null;
  } catch (e) {
    return null;
  }
}
