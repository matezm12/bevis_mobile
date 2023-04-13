library file_picker;

import 'package:bevis/data/models/asset_file.dart';

part 'models/file_type.dart';

abstract class FilePicker {
  Future<AssetFile> pickMediaFileFromGallery({FileType supportedFileType});
  Future<AssetFile> pickFile({FileType supportedFileType});
}
