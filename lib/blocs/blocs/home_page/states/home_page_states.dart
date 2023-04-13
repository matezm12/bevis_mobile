class HomePageState {
  HomePageState({this.appVersion});

  final String appVersion;

  HomePageState copyWith({String appVersion}) {
    return HomePageState(appVersion: appVersion ?? this.appVersion);
  }
}