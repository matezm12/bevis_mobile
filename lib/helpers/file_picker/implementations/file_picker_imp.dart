import 'package:bevis/data/models/asset_file.dart';
import 'package:bevis/helpers/file_picker/file_picker.dart';
import 'package:bevis/helpers/file_picker/implementations/mappers/file_picker_result_to_picked_file_mapper.dart';
import 'package:bevis/helpers/file_picker/implementations/mappers/file_type_mapper.dart';
import 'package:bevis/helpers/file_picker/implementations/mappers/file_type_to_extensions_mapper.dart';
import 'package:file_picker/file_picker.dart' as fp;

class FilePickerImp implements FilePicker {
  Set<FileType> get _validMediaFileTypes => {
        FileType.media,
        FileType.video,
        FileType.image,
      };

  Future<AssetFile> pickMediaFileFromGallery(
      {FileType supportedFileType = FileType.media}) async {
    if (!_validMediaFileTypes.contains(supportedFileType)) {
      return null;
    }

    return pickFile(supportedFileType: supportedFileType);
  }

  Future<AssetFile> pickFile(
      {FileType supportedFileType = FileType.any}) async {
    final fileType = mapFileType(supportedFileType);
    final supportedExtensions = mapFileTypeToExtensions(supportedFileType);

    fp.FilePickerResult result = await fp.FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: supportedExtensions,
      allowMultiple: false,
    );

    if (result != null) {
      try {
        final file = result.files.single;
        final pickedFileResult = mapPlatformFileToAssetFile(file);

        return pickedFileResult;
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
