import 'package:bevis/data/models/asset_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:mime/mime.dart';

Future<AssetFile> mapPickedFileToAssetFile(PickedFile pickedFile) async {
  final filename = basename(pickedFile.path);

  return AssetFile(
    bytes: await pickedFile.readAsBytes(),
    filename: filename,
    file: File(pickedFile.path),
    mimeType: lookupMimeType(filename),
  );
}
