import 'package:bevis/data/top_up/payment_history.dart';
import 'package:flutter/material.dart';
import 'coin_info.dart';

class BevisAsset {
  String name;
  String assetId;
  String createdDate;
  String fileUrl;
  String fileType;
  String assetTypeName;
  CoinInfo coinInfo;
  bool isEncrypted = false;

  BevisAsset.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    assetId = json['assetId'];
    createdDate = json["createdDate"];
    assetTypeName = json["assetTypeName"];
    fileUrl = json["fileUrl"];
    fileType = json["fileType"] ?? "";
    coinInfo =
        json["coinInfo"] != null ? CoinInfo.fromJson(json["coinInfo"]) : null;
    isEncrypted = json['encrypted'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['assetId'] = assetId;
    return data;
  }

  bool isImage() {
    return fileType.contains("JPG") ||
        fileType.contains("JPEG") ||
        fileType.contains("PNG");
  }

  bool isPDF() {
    return fileType.contains("PDF");
  }
}

class BevisAssetPagination {
  List<BevisAsset> assets = <BevisAsset>[];
  Pagination pagination = Pagination();

  BevisAssetPagination({@required this.assets, @required this.pagination});
}
