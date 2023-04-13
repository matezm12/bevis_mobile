import 'package:bevis/data/models/asset_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'dart:io';

AssetFile mapPlatformFileToAssetFile(PlatformFile result) {
  final mimeType = lookupMimeType(result.name);

  final file = kIsWeb ? File.fromRawPath(result.bytes) : File(result.path);

  final pickedFile = AssetFile(
    bytes: kIsWeb ? result.bytes : file.readAsBytesSync(),
    mimeType: mimeType,
    filename: result.name,
    file: file,
  );

  return pickedFile;
}
