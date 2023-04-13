import 'package:bevis/data/models/image_asset.dart';

class WriteAssetState {
  WriteAssetState({this.assetId});

  final String assetId;

  WriteAssetState copyWith({String assetId}) {
    return WriteAssetState(assetId: assetId);
  }
}

class PreparingAssetFile extends WriteAssetState {}

class NeedToGrantLocationPermission extends WriteAssetState {}

class BevisFileAssetCreated extends WriteAssetState {
  BevisFileAssetCreated(this.uploadAsset);

  final BevisUploadAssets uploadAsset;
}

class FailedToPrepareFile extends WriteAssetState {}
