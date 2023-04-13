abstract class ScanCodeState {}

class ScanCodeInitialState extends ScanCodeState {}

class ScanningFailed extends ScanCodeState {
  final String reason;

  ScanningFailed(this.reason);
}

class ScannerDidScanAsset extends ScanCodeState {
  final String publicKey;

  ScannerDidScanAsset(this.publicKey);
}