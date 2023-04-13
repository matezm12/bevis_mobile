import 'dart:io';

import 'package:bevis/data/models/asset.dart';
import 'package:flutter/cupertino.dart';

abstract class ConfrimPaymentEvent {}

class UploadFile extends ConfrimPaymentEvent {
  File file;
  int orderId;
  Asset asset;

  UploadFile({@required this.file, @required this.orderId, @required this.asset});
}