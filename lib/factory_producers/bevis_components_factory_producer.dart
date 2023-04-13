import 'dart:io';

import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/factories/bevis_components_factory/implementations/android_bevis_components_factory.dart';
import 'package:bevis/factories/bevis_components_factory/implementations/ios_bevis_components_factory.dart';
import 'package:bevis/factories/bevis_components_factory/implementations/web_bevis_components_factory.dart';
import 'package:flutter/foundation.dart';

class BevisComponentsFactoryProducer {
  BevisComponentsFactory getFactory() {
    if (kIsWeb) {
      return WebBevisComponentsFactory();
    } else if (Platform.isIOS) {
      return IosBevisComponentsFactory();
    } else if (Platform.isAndroid) {
      return AndroidBevisComponentsFactory();
    }

    return null;
  }
}
