abstract class FileSizeInfoProvider {
  Future<String> getHumanReadableFileSizeString(List<int> fileData);
}