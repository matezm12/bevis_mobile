import 'package:bevis/helpers/image_resolution_provider/models/image_resolution.dart';

abstract class ImageResolutionProvider {
  Future<ImageResolution> getResolutionForImage(List<int> imageData);
}