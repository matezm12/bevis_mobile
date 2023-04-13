import 'dart:io';

abstract class AssetFileEncoder {
  Future<File> encodeAssetFileWithPassword(File assetFile, String password);
}