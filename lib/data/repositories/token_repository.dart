import 'package:bevis/data/models/token.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

abstract class TokenRepository implements Repository<Token> {
  Future<RestRepositoryResult<List<Token>>>loadTokensFromWallet(String publicKey);
}