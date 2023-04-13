import 'dart:io';

import 'package:bevis/helpers/asset_file_encoder/asset_file_encoder.dart';
import 'package:flutter_zip_archive/flutter_zip_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bevis/extensions/file/get_file_name.dart';

class ZipAssetFileEncoder implements AssetFileEncoder {
  final ZipArchiver _zipArchiver = ZipArchiver();

  Future<File> encodeAssetFileWithPassword(
      File assetFile, String password) async {
    final tempDirectory = await getTemporaryDirectory();
    
    try {
      final createdZipFilePath = await _zipArchiver.zipFile(
        sourceFilePath: assetFile.path,
        archiveDestinationDirectoryPath:
            tempDirectory.path + '/${assetFile.filename}.zip',
        password: password,
      );

      return File(createdZipFilePath);
    } on Exception catch (e) {
      print(e.toString());
    }

    return null;
  }
}
