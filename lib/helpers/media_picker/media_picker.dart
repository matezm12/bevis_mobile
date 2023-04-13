import 'package:bevis/data/models/asset_file.dart';

part 'models/media_source.dart';

abstract class MediaPicker {
  Future<AssetFile> pickImageFileFromSource(MediaSource source);
  Future<AssetFile> pickImageVideoFromSource(MediaSource source);
}