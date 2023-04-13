import 'package:bevis/app/app_config.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' as provider;

class AppConfigProvider extends provider.Provider<AppConfig> {
  AppConfigProvider({
    Key key,
    @required provider.Create<AppConfig> create,
    Widget child,
    bool lazy,
  }) : super(
          key: key,
          create: create,
          dispose: (_, __) {},
          child: child,
          lazy: lazy,
        );

  static AppConfig of(BuildContext context, {bool listen = false}) {
    try {
      return provider.Provider.of<AppConfig>(context, listen: listen);
    } on provider.ProviderNotFoundException catch (e) {
      if (e.valueType != AppConfig) rethrow;
      throw FlutterError(
        '''
        AppConfigProvider.of() called with a context that does not contain an AppConfig.
        No ancestor could be found starting from the context that was passed to AppConfigProvider.of().
        This can happen if the context you used comes from a widget above the AppConfigProvider.
        The context used was: $context
        ''',
      );
    }
  }
}
