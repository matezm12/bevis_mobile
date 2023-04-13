import 'package:bevis/blocs/states/base_state.dart';
import 'package:flutter/foundation.dart';

abstract class ClipboardState extends BaseState {
  ClipboardState({bool isLoading}) : super(isLoading: isLoading);
}

class ClipboardInitialState extends ClipboardState {
  ClipboardInitialState() : super(isLoading: false);
}

class TextCopiedToClipboard extends ClipboardState {
  final String text;

  TextCopiedToClipboard({@required this.text});
}
