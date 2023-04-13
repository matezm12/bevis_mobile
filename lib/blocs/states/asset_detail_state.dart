import 'package:bevis/data/asset_detail.dart';

import 'base_state.dart';

class AssetDetailState extends BaseState {
  AssetDetailState({bool isLoading = false}) : super(isLoading: isLoading);
}

class AssetFilesState extends AssetDetailState {
  List<AssetFile> files;
  AssetFilesState({bool isLoading = false, this.files})
      : super(isLoading: isLoading);
}
