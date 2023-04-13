import 'package:bevis/data/models/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetIconPreviewWidget extends StatelessWidget {
  AssetIconPreviewWidget({
    @required this.assetFile,
  });

  final BevisUploadAssets assetFile;

  @override
  Widget build(BuildContext context) {
    const double imageSide = 160;
    const imageFit = BoxFit.cover;

    final fileMimeType = assetFile.fileType;

    if (fileMimeType.contains('image')) {
      return Image.memory(
        assetFile.pickedFile.bytes,
        height: imageSide,
        width: imageSide,
        fit: imageFit,
      );
    } else if (fileMimeType.contains('pdf')) {
      return SvgPicture.asset(
        'assets/asset_preview_page/pdf_icon.svg',
        width: imageSide,
        height: imageSide,
        fit: imageFit,
      );
    } else if (fileMimeType.contains('wordprocessingml') || fileMimeType.contains('msword')) {
      return SvgPicture.asset(
        'assets/asset_preview_page/doc_icon.svg',
        width: imageSide,
        height: imageSide,
        fit: imageFit,
      );
    } else {
      return Container(
        width: imageSide,
        height: imageSide,
      );
    }
  }
}
