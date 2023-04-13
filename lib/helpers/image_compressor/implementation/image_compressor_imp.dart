import 'package:bevis/helpers/image_compressor/image_compressor.dart';
import 'package:flutter/foundation.dart';

class ImageCompressorImp implements ImageCompressor {
  @override
  Future<List<int>> compressImage({@required List<int> imageBytes, @required double quality}) async {
    return imageBytes;
  }
}