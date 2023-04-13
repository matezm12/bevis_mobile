import 'package:bevis/helpers/file_picker/file_picker.dart';

List<String> mapFileTypeToExtensions(FileType fileType) {
  if(fileType == null) {
    return null;
  }

  switch (fileType) {
    case FileType.any:
      return null;
    case FileType.audio:
      return null;
    case FileType.image:
      return null;
    case FileType.video:
      return null;
    case FileType.media:
      return null;
    case FileType.doc:
      return ['doc'];
    case FileType.pdf:
      return ['pdf'];
  }

  return null;
}
