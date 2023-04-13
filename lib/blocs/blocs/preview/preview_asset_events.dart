abstract class PreviewAssetEvent {}

class ChangeBlockchain extends PreviewAssetEvent {
  final String selectedBlockchain;

  ChangeBlockchain(this.selectedBlockchain);
}

class ProtectAssetButtonTapped extends PreviewAssetEvent {}

class ProtectAssetFormInputHasChanged extends PreviewAssetEvent {
  ProtectAssetFormInputHasChanged(this.password, this.repeatPassword);

  final String password;
  final String repeatPassword;
}

class EditAssetProtectionPasswordButtonTapped extends PreviewAssetEvent {}

class EditAssetProtectionPasswordInputChanged extends PreviewAssetEvent {
  EditAssetProtectionPasswordInputChanged(
    this.oldPassword,
    this.password,
    this.repeatPassword,
  );

  final String oldPassword;
  final String password;
  final String repeatPassword;
}

class ChangeAssetProtectionPassword extends PreviewAssetEvent {
  ChangeAssetProtectionPassword(
    this.oldPassword,
    this.password,
    this.repeatPassword,
  );

  final String oldPassword;
  final String password;
  final String repeatPassword;
}

class UnprotectAsset extends PreviewAssetEvent {}

class PasswordProtectAsset extends PreviewAssetEvent {
  PasswordProtectAsset(
    this.password,
    this.repeatPassword,
  );

  final String password;
  final String repeatPassword;
}

class WriteToBlockchain extends PreviewAssetEvent {}
