String getFileType(String fileName) {
  int lastDot = fileName.lastIndexOf('.', fileName.length - 1);
  if (lastDot != -1) {
    String extension = fileName.substring(lastDot + 1);
    return extension;
  }
  return "unkown";
}
