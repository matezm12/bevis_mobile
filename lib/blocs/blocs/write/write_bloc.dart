import 'dart:async';
import 'package:bevis/blocs/events/write_bloc_events.dart';
import 'package:bevis/blocs/states/write_asset_states.dart';
import 'package:bevis/data/models/asset_file.dart';
import 'package:bevis/data/models/image_asset.dart';
import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/helpers/file_picker/file_picker.dart';
import 'package:bevis/helpers/gps_location_provider/gps_location_provider.dart'
    as loc;
import 'package:bevis/helpers/media_picker/media_picker.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteBloc extends Bloc<WriteAssetEvent, WriteAssetState> {
  WriteBloc({
    @required FilePicker filePicker,
    @required MediaPicker mediaPicker,
    @required BevisAssetFileMetadataProvider bevisAssetMetadataProvider,
    String assetId,
  })  : _filePicker = filePicker,
        _mediaPicker = mediaPicker,
        _bevisAssetMetadataProvider = bevisAssetMetadataProvider,
        _assetId = assetId,
        super(WriteAssetState(assetId: assetId));

  final FilePicker _filePicker;
  final MediaPicker _mediaPicker;
  final BevisAssetFileMetadataProvider _bevisAssetMetadataProvider;
  String _assetId;

  @override
  Stream<WriteAssetState> mapEventToState(
    WriteAssetEvent event,
  ) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String imageQuality = sharedPreferences.get("img_quality") ?? "low";

    if (event is PickMediaFileFromGallery) {
      final pickedFile = await _filePicker.pickMediaFileFromGallery();

      if (pickedFile == null) {
        return;
      }

      yield* _prepareBevisFileAsset(pickedFile);
    } else if (event is PickFileFromGallery) {
      final pickedFile = await _filePicker.pickFile();
      if (pickedFile != null) {
        yield* _prepareBevisFileAsset(pickedFile);
      }
    } else if (event is TakePicture) {
      final pickedMediaFile =
          await _mediaPicker.pickImageFileFromSource(MediaSource.camera);

      if (pickedMediaFile == null) {
        return;
      }

      yield* _prepareBevisFileAsset(pickedMediaFile);
    } else if (event is SetAssetId) {
      _assetId = event.assetId;
      yield state.copyWith(assetId: _assetId);
    }
  }

  Stream<WriteAssetState> _prepareBevisFileAsset(AssetFile pickedFile) async* {
    try {
      yield PreparingAssetFile();

      final bevisAssetMetadata = await _bevisAssetMetadataProvider
          .getBevisAssetMetadata(pickedFile.bytes, pickedFile.mimeType);

      final bevisUploadAsset = BevisUploadAssets.from(
        metadata: bevisAssetMetadata,
        pickedFile: pickedFile,
        assetId: _assetId,
      );

      yield BevisFileAssetCreated(bevisUploadAsset);
    } on loc.LocationPermissionNotGranted catch (_) {
      yield NeedToGrantLocationPermission();
    } on Exception catch (_) {
      yield FailedToPrepareFile();
    }
  }
}
