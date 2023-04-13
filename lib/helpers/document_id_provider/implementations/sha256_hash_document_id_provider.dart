import 'package:bevis/helpers/document_id_provider/document_id_provider.dart';
import 'package:crypto/crypto.dart';

class SHA256HashDocumentIdProvider implements DocumentIdProvider {
  @override
  Future<String> getDocumentId(List<int> documentData) async {
    return sha256.convert(documentData).toString();
  }
}
