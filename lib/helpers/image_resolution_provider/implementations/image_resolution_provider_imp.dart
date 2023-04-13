import 'package:bevis/helpers/image_resolution_provider/image_resolution_provider.dart';
import 'package:bevis/helpers/image_resolution_provider/models/image_resolution.dart';
import 'package:image/image.dart';

class ImageResolutionProviderImp implements ImageResolutionProvider {
  @override
  Future<ImageResolution> getResolutionForImage(List<int> imageData) async {
    Image image = decodeImage(imageData);

    return ImageResolution(
      width: image.width,
      height: image.height,
    );
  }
}
