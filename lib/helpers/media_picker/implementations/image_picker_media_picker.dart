import 'package:bevis/data/models/asset_file.dart';
import 'package:bevis/helpers/media_picker/implementations/mappers/media_source_mapper.dart';
import 'package:bevis/helpers/media_picker/implementations/mappers/picked_file_mapper.dart';
import 'package:bevis/helpers/media_picker/media_picker.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerMediaPicker implements MediaPicker {

  final ImagePicker _picker = ImagePicker();

  @override
  Future<AssetFile> pickImageFileFromSource(MediaSource source) async {
    final imageSource = mapMediaSourceToImageSource(source);
    final pickedImage = await _picker.getImage(source: imageSource);
    final assetFile = await mapPickedFileToAssetFile(pickedImage);
    return assetFile;
  }

  @override
  Future<AssetFile> pickImageVideoFromSource(MediaSource source) async {
    final videoSource = mapMediaSourceToImageSource(source);
    final pickedVideo = await _picker.getVideo(source: videoSource);
    final assetFile = mapPickedFileToAssetFile(pickedVideo);
    return assetFile;
  }
}