import 'package:bevis/helpers/bevis_asset_file_metadata_provider/states/bevis_asset_metadata_provider_states.dart';

abstract class WriteAssetEvent {}

class TakePicture extends WriteAssetEvent {}

class PickMediaFileFromGallery extends WriteAssetEvent {}

class PickFileFromGallery extends WriteAssetEvent {}

class UpdateCollectingAssetInfoState extends WriteAssetEvent {
  final BevisAssetMetadataProviderStates assetMetadataProviderState;

  UpdateCollectingAssetInfoState(this.assetMetadataProviderState);
}

class SetAssetId extends WriteAssetEvent {
  SetAssetId(this.assetId);
  
  final String assetId;
}
