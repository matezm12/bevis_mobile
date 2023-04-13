import 'dart:io';

import 'package:bevis/blocs/blocs/preview/preview_asset_events.dart';
import 'package:bevis/blocs/blocs/preview/preview_asset_states.dart';
import 'package:bevis/data/models/image_asset.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bevis/helpers/asset_file_encoder/asset_file_encoder.dart';
import 'package:bevis/utils/helpers/validators/asset_password_validator/asset_password_validator.dart';
import 'package:bevis/utils/helpers/validators/asset_password_validator/password_validation_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewAssetBloc extends Bloc<PreviewAssetEvent, PreviewAssetState> {
  PreviewAssetBloc({
    @required this.uploadAssets,
    @required this.assetNetworkRepository,
    @required AssetFileEncoder assetEncoder,
  })  : _assetEncoder = assetEncoder,
        super(
          PreviewAssetState(
            uploadAssets: uploadAssets,
            selectedBlockchain: 'BCH',
            isNewAsset: uploadAssets.assetId == null,
            assetProtected: false,
          ),
        );

  final BevisUploadAssets uploadAssets;
  final AssetNetworkRepository assetNetworkRepository;
  final AssetPasswordValidator _assetPasswordValidator =
      AssetPasswordValidator();
  final AssetFileEncoder _assetEncoder;
  String _assetProtectionPassword;

  @override
  Stream<PreviewAssetState> mapEventToState(PreviewAssetEvent event) async* {
    if (event is ChangeBlockchain) {
      yield state.copyWith(selectedBlockchain: event.selectedBlockchain);
    } else if (event is ProtectAssetButtonTapped) {
      yield state.copyWith(
        protectAssetFormState: ProtectAssetFormState(
          isSubmitButtonEnabled: false,
        ),
      );
      yield ShowProtectAssetWithPasswordPopup(
        uploadAssets: state.uploadAssets,
        isNewAsset: state.isNewAsset,
        selectedBlockchain: state.selectedBlockchain,
        assetProtected: state.assetProtected,
        protectAssetFormState: state.protectAssetFormState,
      );
    } else if (event is ProtectAssetFormInputHasChanged) {
      yield state.copyWith(
        protectAssetFormState: ProtectAssetFormState(
          isSubmitButtonEnabled:
              event.password.isNotEmpty && event.repeatPassword.isNotEmpty,
        ),
      );
    } else if (event is PasswordProtectAsset) {
      try {
        _assetPasswordValidator.validatePasswordInput(
            event.password, event.repeatPassword);

        _assetProtectionPassword = event.password;

        yield PasswordProtectSuccess(
          assetProtected: true,
          protectAssetFormState: state.protectAssetFormState,
          selectedBlockchain: state.selectedBlockchain,
          isNewAsset: state.isNewAsset,
          uploadAssets: state.uploadAssets,
        );
      } on PasswordsDoNotMatchException catch (_) {
        yield state.copyWith(
          protectAssetFormState: ProtectAssetFormState(
            isSubmitButtonEnabled:
                state.protectAssetFormState.isSubmitButtonEnabled,
            protectAssetFormValidationFailureReason:
                ProtectAssetFormValidationFailureReason.passwordsDoNotMatch,
          ),
        );
      }
    } else if (event is EditAssetProtectionPasswordButtonTapped) {
      yield state.copyWith(
        editAssetPasswordFormState:
            EditAssetPasswordFormState(isSubmitButtonEnabled: false),
      );

      yield ShowEditAssetPasswordDialog(
        uploadAssets: state.uploadAssets,
        isNewAsset: state.isNewAsset,
        selectedBlockchain: state.selectedBlockchain,
        assetProtected: state.assetProtected,
        editAssetPasswordFormState: state.editAssetPasswordFormState,
      );
    } else if (event is EditAssetProtectionPasswordInputChanged) {
      yield state.copyWith(
        editAssetPasswordFormState: EditAssetPasswordFormState(
          isSubmitButtonEnabled: event.oldPassword.isNotEmpty &&
              event.password.isNotEmpty &&
              event.repeatPassword.isNotEmpty,
        ),
      );
    } else if (event is ChangeAssetProtectionPassword) {
      if (event.oldPassword != _assetProtectionPassword) {
        yield state.copyWith(
          editAssetPasswordFormState: EditAssetPasswordFormState(
            isSubmitButtonEnabled:
                state.editAssetPasswordFormState.isSubmitButtonEnabled,
            editAssetPasswordFromValidationFailureReason:
                EditAssetPasswordFromValidationFailureReason.wrongOldPassword,
          ),
        );
        return;
      }

      if (event.password == _assetProtectionPassword) {
        yield state.copyWith(
          editAssetPasswordFormState: EditAssetPasswordFormState(
            isSubmitButtonEnabled:
                state.editAssetPasswordFormState.isSubmitButtonEnabled,
            editAssetPasswordFromValidationFailureReason:
                EditAssetPasswordFromValidationFailureReason
                    .newPasswordEqualsOld,
          ),
        );
        return;
      }

      try {
        _assetPasswordValidator.validatePasswordInput(
            event.password, event.repeatPassword);
        yield EditAssetPasswordSuccess(
          uploadAssets: state.uploadAssets,
          isNewAsset: state.isNewAsset,
          selectedBlockchain: state.selectedBlockchain,
          editAssetPasswordFormState: state.editAssetPasswordFormState,
          assetProtected: state.assetProtected,
        );
      } on PasswordsDoNotMatchException catch (_) {
        yield state.copyWith(
          editAssetPasswordFormState: EditAssetPasswordFormState(
            isSubmitButtonEnabled:
                state.editAssetPasswordFormState.isSubmitButtonEnabled,
            editAssetPasswordFromValidationFailureReason:
                EditAssetPasswordFromValidationFailureReason
                    .passwordsDoNotMatch,
          ),
        );
      }
    } else if (event is UnprotectAsset) {
      yield state.copyWith(assetProtected: false);
      yield EditAssetPasswordSuccess(
        uploadAssets: state.uploadAssets,
        isNewAsset: state.isNewAsset,
        selectedBlockchain: state.selectedBlockchain,
        editAssetPasswordFormState: state.editAssetPasswordFormState,
        assetProtected: state.assetProtected,
      );
    } else if (event is WriteToBlockchain) {
      final pickedFile = uploadAssets.pickedFile;
      List<int> fileToUploadData = pickedFile.bytes;

      if (state.assetProtected) {
        yield EncodingAssetState(
          assetProtected: state.assetProtected,
          isNewAsset: state.isNewAsset,
          selectedBlockchain: state.selectedBlockchain,
          uploadAssets: state.uploadAssets,
        );

        File zipFile;

        if(!kIsWeb) {
          zipFile = await _assetEncoder.encodeAssetFileWithPassword(
          pickedFile.file,
          _assetProtectionPassword,
        );

        if (zipFile == null) {
          yield FailedToEncodeAssetState(
            assetProtected: state.assetProtected,
            uploadAssets: state.uploadAssets,
            selectedBlockchain: state.selectedBlockchain,
            isNewAsset: state.isNewAsset,
          );
          return;
        }
        }

        fileToUploadData = zipFile.readAsBytesSync();
      }

      yield WritingToBlockchainState(
        uploadAssets: state.uploadAssets,
        selectedBlockchain: state.selectedBlockchain,
        isNewAsset: state.isNewAsset,
        assetProtected: state.assetProtected,
      );

      try {
        final nPages = uploadAssets.numberOfPages != null ? int.tryParse(uploadAssets.numberOfPages) : 0;

        if (uploadAssets.assetId == null) {
          await assetNetworkRepository.writeAsset(
            assetFileData: fileToUploadData,
            assetImage: uploadAssets,
            blockChain: state.selectedBlockchain,
            numberOfPages: nPages,
            deviceId: uploadAssets.deviceID,
            assetEncrypted: state.assetProtected,
          );
        } else {
          await assetNetworkRepository.addAssetToAssetID(
            assetFileData: fileToUploadData,
            assetImage: uploadAssets,
            assetId: uploadAssets.assetId,
            numberOfPages: nPages,
            deviceId: uploadAssets.deviceID,
            assetEncrypted: state.assetProtected,
          );
        }

        yield WriteToBlockchainSuccess(
          uploadAssets: state.uploadAssets,
          selectedBlockchain: state.selectedBlockchain,
          isNewAsset: state.isNewAsset,
          assetProtected: state.assetProtected,
        );
      } on DioError catch (e) {
        print(e.toString());

        yield WriteToBlockchainFailure(
          assetProtected: state.assetProtected,
          isNewAsset: state.isNewAsset,
          selectedBlockchain: state.selectedBlockchain,
          uploadAssets: state.uploadAssets,
        );
      }
    }
  }
}
