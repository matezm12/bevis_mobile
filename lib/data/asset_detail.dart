class AssetFile {
  String transactionId;
  String ipfsHash;
  String url;
  String fileType;
  bool encrypted;

  AssetFile({
    this.transactionId,
    this.ipfsHash,
    this.url,
    this.encrypted = false,
  });

  AssetFile.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    ipfsHash = json['ipfsHash'];
    url = json['url'];
    fileType = json['fileType'];
    encrypted = json['encrypted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['ipfsHash'] = this.ipfsHash;
    data['url'] = this.url;
    data['fileType'] = this.fileType;
    data['encrypted'] = this.encrypted;
    return data;
  }

  bool isImage() {
    return fileType.contains("JPG") ||
        fileType.contains("JPEG") ||
        fileType.contains("PNG");
  }

  bool isPDF() {
    return fileType.contains("PDF");
  }
}
