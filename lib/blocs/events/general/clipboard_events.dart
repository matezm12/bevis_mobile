import 'package:flutter/widgets.dart';

abstract class ClipboardEvent {}

class CopyTextToClipboard extends ClipboardEvent {
  final String text;

  CopyTextToClipboard({@required this.text});
}