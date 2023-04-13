import 'dart:io';

import 'package:flutter/foundation.dart';

class AssetFile {
  AssetFile({
    @required this.bytes,
    @required this.filename,
    @required this.mimeType,
    @required this.file,
  });

  final List<int> bytes;
  final String filename;
  final String mimeType;
  final File file;
}