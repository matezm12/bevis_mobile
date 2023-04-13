import 'package:bevis/helpers/file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart' as fp;

fp.FileType mapFileType(FileType fileType) {
  if(fileType == null) {
    return null;
  }
  
  switch (fileType) {
    case FileType.image:
      return fp.FileType.image;
    case FileType.video:
      return fp.FileType.video;
    case FileType.media:
      return fp.FileType.media;
    case FileType.audio:
      return fp.FileType.audio;
    case FileType.pdf:
      return fp.FileType.custom;
    case FileType.doc:
      return fp.FileType.custom;
    case FileType.any:
      return fp.FileType.any;
  }
  return null;
}
