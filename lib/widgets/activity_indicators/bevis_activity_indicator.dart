import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BevisActivityIndicator extends StatelessWidget {
  Widget build(BuildContext context) {
    if(kIsWeb) {
      return CircularProgressIndicator();
    }
    
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }
}
