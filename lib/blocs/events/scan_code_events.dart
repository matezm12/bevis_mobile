abstract class ScanCodeEvent {}

class StartScanning extends ScanCodeEvent {
  StartScanning(this.scannedValuesStream);

  Stream<String> scannedValuesStream;
}

class ScannerDidScanValue extends ScanCodeEvent {
  final String value;

  ScannerDidScanValue(this.value);
}