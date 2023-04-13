import 'package:bevis/widgets/app_bars/bevis_app_bar.dart';
import 'package:flutter/material.dart';

class BevisScaffold extends StatelessWidget {
  const BevisScaffold({
    @required this.body,
    @required this.title,
    this.subtitle,
    this.appBarActions,
    this.appBarLeading,
  });

  final Widget body;
  final List<Widget> appBarActions;
  final Widget appBarLeading;
  final String title;
  final String subtitle;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BevisAppBar(
        title: title,
        subtitle: subtitle,
        actions: appBarActions,
        leading: appBarLeading,
      ),
      body: body,
    );
  }
}
