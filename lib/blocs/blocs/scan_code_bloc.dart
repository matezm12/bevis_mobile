import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bevis/utils/regex_patterns.dart';

import 'package:bevis/blocs/events/scan_code_events.dart';
import 'package:bevis/blocs/states/scan_code_states.dart';
import 'package:flutter/rendering.dart';

export 'package:bevis/blocs/events/scan_code_events.dart';
export 'package:bevis/blocs/states/scan_code_states.dart';

class ScanCodeBloc extends Bloc<ScanCodeEvent, ScanCodeState> {
  ScanCodeBloc() : super(ScanCodeInitialState());

  StreamSubscription _qrCodeScanSubsription;

  @override
  Stream<ScanCodeState> mapEventToState(
    ScanCodeEvent event,
  ) async* {
    if (event is StartScanning) {
      _qrCodeScanSubsription = event.scannedValuesStream.listen((barcodeValue) {
        add(ScannerDidScanValue(barcodeValue));
      });
    } else if (event is ScannerDidScanValue) {
      final value = event.value;

      var urlPattern = RegexPatterns.urlPattern;
      var regex = new RegExp(urlPattern, caseSensitive: false);
      if (!regex.hasMatch(value)) {
        _qrCodeScanSubsription?.cancel();
        yield ScannerDidScanAsset(value);
      } else {
        debugPrint('Scanned value: $value');
      }
    }
  }

  @override
  Future<void> close() {
    _qrCodeScanSubsription?.cancel();

    return super.close();
  }
}
