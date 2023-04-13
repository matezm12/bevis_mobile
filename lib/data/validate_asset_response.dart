class AssetValidateResponse {
  String assetId;
  String blockChain;

  AssetValidateResponse({this.assetId, this.blockChain});

  factory AssetValidateResponse.fromJson(dynamic json) {
    return AssetValidateResponse(
      assetId: json["assetId"],
      blockChain: json["blockchain"],
    );
  }

  @override
  String toString() {
    return 'AssetValidateResponse{assetId: $assetId, blockChain: $blockChain}';
  }
}
