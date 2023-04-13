abstract class AssetDetailEvent {}

class LoadAssetDetailEvent extends AssetDetailEvent {
  final String assetId;

  LoadAssetDetailEvent(this.assetId);
}
