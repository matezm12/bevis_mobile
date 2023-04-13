import 'package:flutter/material.dart';

class BevisBarrier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModalBarrier(
      color: Colors.black.withOpacity(0.7),
      dismissible: false,
    );
  }
}
