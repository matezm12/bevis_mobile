import 'package:bevis/data/models/bevis_asset.dart';
import 'package:flutter/widgets.dart';

abstract class AssetListEvent {}

class LoadAssetList extends AssetListEvent {
  final bool isFirstTime;

  LoadAssetList(this.isFirstTime);
}

class RenameAsset extends AssetListEvent {
  final BevisAsset asset;
  final String newName;

  RenameAsset({@required this.asset, @required this.newName});
}

class LoadAsset extends AssetListEvent {
  final BevisAsset asset;

  LoadAsset({@required this.asset});
}

class DeleteAsset extends AssetListEvent {
  final BevisAsset asset;

  DeleteAsset({@required this.asset});
}

class SortAssetByDate extends AssetListEvent {}

class SortAssetByName extends AssetListEvent {}

class SortAssetByType extends AssetListEvent {}
