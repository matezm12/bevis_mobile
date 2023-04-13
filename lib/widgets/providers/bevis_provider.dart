import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BevisProvider<T> extends StatelessWidget {
  BevisProvider({
    @required this.create,
    this.child,
    this.builder,
  });

  final T Function(BuildContext) create;
  final Widget Function(BuildContext, Widget) builder;
  final Widget child;

  static T of<T>(BuildContext context) {
    return Provider.of<T>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: create,
      child: child,
      builder: builder,
    );
  }
}
