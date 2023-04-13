import 'package:bevis/helpers/file_size_info_provider.dart/file_size_info_provider.dart';
import 'package:filesize/filesize.dart';

class FilesizePluginFileSizeInfoProvider implements FileSizeInfoProvider {
  @override
  Future<String> getHumanReadableFileSizeString(List<int> fileData) async {
    return filesize(fileData.length);
  }
}