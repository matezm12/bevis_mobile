import 'package:bevis/blocs/events/asset_detail_bloc.dart';
import 'package:bevis/blocs/states/asset_detail_state.dart';
import 'package:bevis/data/asset_detail.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  AssetNetworkRepository _assetNetworkRepository;

  AssetDetailBloc({@required AssetNetworkRepository assetNetworkRepository})
      : _assetNetworkRepository = assetNetworkRepository,
        super(
          AssetDetailState(isLoading: true),
        );

  @override
  Stream<AssetDetailState> mapEventToState(
    AssetDetailEvent event,
  ) async* {
    if (event is LoadAssetDetailEvent) {
      try {
        final res =
            await _assetNetworkRepository.assetFiles(assetId: event.assetId);

        List<AssetFile> files = <AssetFile>[];

        if (res.data["certificate"] != null) {
          files.add(AssetFile.fromJson(res.data["certificate"]));
        }
        var array = res.data["files"] as dynamic;
        array.forEach((element) {
          files.add(AssetFile.fromJson(element));
        });

        yield AssetFilesState(files: files);

        print("result " + files.length.toString());
      } on DioError catch (e) {
        List<AssetFile> files = <AssetFile>[];

        yield AssetFilesState(files: files);

        print(e.response.toString());
      }
    }
  }
}
