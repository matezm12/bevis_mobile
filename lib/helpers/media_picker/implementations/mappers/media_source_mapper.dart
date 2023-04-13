import 'package:bevis/helpers/media_picker/media_picker.dart';
import 'package:image_picker/image_picker.dart';

ImageSource mapMediaSourceToImageSource(MediaSource mediaSource) {
  switch(mediaSource) {
    case MediaSource.camera:
    return ImageSource.camera;
    case MediaSource.gallery:
    return ImageSource.gallery;
  }

  return null;
}