import 'package:bevis/data/models/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum ProtectAssetFormValidationFailureReason {
  passwordsDoNotMatch,
}

enum EditAssetPasswordFromValidationFailureReason {
  passwordsDoNotMatch,
  wrongOldPassword,
  newPasswordEqualsOld,
}

class ProtectAssetFormState extends Equatable {
  ProtectAssetFormState({
    @required this.isSubmitButtonEnabled,
    this.protectAssetFormValidationFailureReason,
  });

  final ProtectAssetFormValidationFailureReason
      protectAssetFormValidationFailureReason;
  final bool isSubmitButtonEnabled;

  @override
  List<Object> get props => [
        isSubmitButtonEnabled,
        protectAssetFormValidationFailureReason,
      ];
}

class EditAssetPasswordFormState extends Equatable {
  EditAssetPasswordFormState({
    @required this.isSubmitButtonEnabled,
    this.editAssetPasswordFromValidationFailureReason,
  });

  final EditAssetPasswordFromValidationFailureReason
      editAssetPasswordFromValidationFailureReason;
  final bool isSubmitButtonEnabled;

  @override
  List<Object> get props => [
        isSubmitButtonEnabled,
        editAssetPasswordFromValidationFailureReason,
      ];
}

class PreviewAssetState extends Equatable {
  PreviewAssetState({
    @required this.uploadAssets,
    @required this.selectedBlockchain,
    @required this.isNewAsset,
    @required this.assetProtected,
    this.protectAssetFormState,
    this.editAssetPasswordFormState,
  });

  final BevisUploadAssets uploadAssets;
  final String selectedBlockchain;
  final bool isNewAsset;
  final bool assetProtected;
  final ProtectAssetFormState protectAssetFormState;
  final EditAssetPasswordFormState editAssetPasswordFormState;

  @override
  List<Object> get props => [
        uploadAssets,
        selectedBlockchain,
        isNewAsset,
        assetProtected,
        protectAssetFormState,
        editAssetPasswordFormState,
      ];

  PreviewAssetState copyWith({
    BevisUploadAssets uploadAssets,
    String selectedBlockchain,
    bool isNewAsset,
    bool assetProtected,
    ProtectAssetFormState protectAssetFormState,
    EditAssetPasswordFormState editAssetPasswordFormState,
  }) {
    return PreviewAssetState(
      uploadAssets: uploadAssets ?? this.uploadAssets,
      selectedBlockchain: selectedBlockchain ?? this.selectedBlockchain,
      isNewAsset: isNewAsset ?? this.isNewAsset,
      assetProtected: assetProtected ?? this.assetProtected,
      protectAssetFormState:
          protectAssetFormState ?? this.protectAssetFormState,
      editAssetPasswordFormState:
          editAssetPasswordFormState ?? this.editAssetPasswordFormState,
    );
  }
}

class ShowProtectAssetWithPasswordPopup extends PreviewAssetState {
  ShowProtectAssetWithPasswordPopup({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
    @required ProtectAssetFormState protectAssetFormState,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
          protectAssetFormState: protectAssetFormState,
        );
}

class PasswordProtectSuccess extends PreviewAssetState {
  PasswordProtectSuccess({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
    @required ProtectAssetFormState protectAssetFormState,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
          protectAssetFormState: protectAssetFormState,
        );
}

class ShowEditAssetPasswordDialog extends PreviewAssetState {
  ShowEditAssetPasswordDialog({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
    @required EditAssetPasswordFormState editAssetPasswordFormState,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
          editAssetPasswordFormState: editAssetPasswordFormState,
        );
}

class EditAssetPasswordSuccess extends PreviewAssetState {
  EditAssetPasswordSuccess({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
    @required EditAssetPasswordFormState editAssetPasswordFormState,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
          editAssetPasswordFormState: editAssetPasswordFormState,
        );
}

class WritingToBlockchainState extends PreviewAssetState {
  WritingToBlockchainState({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
        );
}

class EncodingAssetState extends PreviewAssetState {
  EncodingAssetState({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
        );
}

class FailedToEncodeAssetState extends PreviewAssetState {
  FailedToEncodeAssetState({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
        );
}

class WriteToBlockchainSuccess extends PreviewAssetState {
  WriteToBlockchainSuccess({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
        );
}

class WriteToBlockchainFailure extends PreviewAssetState {
  WriteToBlockchainFailure({
    @required BevisUploadAssets uploadAssets,
    @required String selectedBlockchain,
    @required bool isNewAsset,
    @required bool assetProtected,
  }) : super(
          uploadAssets: uploadAssets,
          selectedBlockchain: selectedBlockchain,
          isNewAsset: isNewAsset,
          assetProtected: assetProtected,
        );
}
