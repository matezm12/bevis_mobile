class BaseState {
  final bool isLoading;

  BaseState({this.isLoading = false});

  BaseState copyWith({bool isLoading}) {
    return BaseState(isLoading: isLoading);
  }
}
