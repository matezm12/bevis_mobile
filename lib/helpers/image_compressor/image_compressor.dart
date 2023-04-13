import 'package:flutter/foundation.dart';

abstract class ImageCompressor {
  Future<List<int>> compressImage({@required List<int> imageBytes, @required double quality});
}