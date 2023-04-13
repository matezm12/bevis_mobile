import 'package:bevis/data/models/bevis_asset.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetPreviewIcon extends StatelessWidget {
  AssetPreviewIcon(this.asset);

  final BevisAsset asset;

  Widget build(BuildContext context) {
    return Container(
      height: 33,
      width: 30,
      child:
          asset.isEncrypted ? _encryptedAssetIcon() : _notEncryptedAssetIcon(),
    );
  }

  Widget _encryptedAssetIcon() {
    return SvgPicture.asset('assets/home/asset_preview_image_placeholder.svg');
  }

  Widget _notEncryptedAssetIcon() {
    return asset.fileType.toLowerCase().contains("pdf")
        ? Image.asset(
            "assets/pdf.png",
            fit: BoxFit.cover,
            width: 43,
            height: 34,
          )
        : CachedNetworkImage(
            width: 43,
            height: 34,
            imageUrl: asset.fileUrl == null ? "" : asset.fileUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Image.asset("assets/placeholder-vertical.jpg"),
            errorWidget: (context, url, obj) =>
                Image.asset("assets/placeholder-vertical.jpg"),
          );
  }
}
