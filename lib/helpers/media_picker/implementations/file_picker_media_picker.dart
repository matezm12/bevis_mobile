import 'package:bevis/data/models/asset_file.dart';
import 'package:bevis/helpers/file_picker/file_picker.dart';
import 'package:bevis/helpers/media_picker/media_picker.dart';

class FilePickerMediaPicker implements MediaPicker {
  FilePickerMediaPicker(this._filePicker);

  final FilePicker _filePicker;

  @override
  Future<AssetFile> pickImageFileFromSource(MediaSource source) async {
    final pickedImage =
        await _filePicker.pickMediaFileFromGallery(supportedFileType: FileType.image);
    return pickedImage;
  }

  @override
  Future<AssetFile> pickImageVideoFromSource(MediaSource source) async {
    final pickedVideo =
        await _filePicker.pickMediaFileFromGallery(supportedFileType: FileType.video);
    return pickedVideo;
  }
}
