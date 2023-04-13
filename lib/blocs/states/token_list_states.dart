import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/models/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

class TokenListState extends BaseState {
  final List<Token> tokens;

  TokenListState({@required bool isLoading, @required this.tokens})
      : super(isLoading: isLoading);

  @override
  TokenListState copyWith({bool isLoading, List<Token> tokens}) {
    return TokenListState(
        isLoading: isLoading ?? this.isLoading, tokens: tokens ?? this.tokens);
  }
}

class FailedToLoadTokens extends TokenListState {
  final NetworkError error;

  FailedToLoadTokens({bool isLoading, List<Token> tokens, this.error}): super(isLoading: isLoading, tokens: tokens);
}
