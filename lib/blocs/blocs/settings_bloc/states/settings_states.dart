class SettingsPageState {
  SettingsPageState({this.imageQuality, this.blockchain});

  final String imageQuality;
  final String blockchain;

  SettingsPageState copyWith({String imageQuality, String blockchain}) {
    return SettingsPageState(
      imageQuality: imageQuality ?? this.imageQuality,
      blockchain: blockchain ?? this.blockchain,
    );
  }
}
