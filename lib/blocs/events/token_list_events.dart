abstract class TokenListEvent {}

class LoadTokenList extends TokenListEvent {
  final String walletAddress;

  LoadTokenList(this.walletAddress);
}