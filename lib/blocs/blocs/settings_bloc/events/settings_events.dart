abstract class SettingsEvent {}

class ChangeDefaultImageQuality extends SettingsEvent {
  ChangeDefaultImageQuality(this.newQuality);

  final String newQuality;
}

class ChangeDefaultBlockchain extends SettingsEvent {
  ChangeDefaultBlockchain(this.newBlockchain);
  
  final String newBlockchain;
}

class RefreshData extends SettingsEvent {}