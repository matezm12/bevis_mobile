abstract class DocumentIdProvider {
  Future<String> getDocumentId(List<int> documentData);
}