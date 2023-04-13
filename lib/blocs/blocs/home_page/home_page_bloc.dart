import 'package:bevis/blocs/blocs/home_page/events/home_page_events.dart';
import 'package:bevis/blocs/blocs/home_page/states/home_page_states.dart';
import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({@required AppVersionProvider appVersionProvider})
      : _appVersionProvider = appVersionProvider,
        super(HomePageState()) {
    add(RefreshAppVersion());
  }

  final AppVersionProvider _appVersionProvider;

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is RefreshAppVersion) {
      final appVersion = await _appVersionProvider.getAppVersion();
      yield state.copyWith(appVersion: appVersion);
    }
  }
}
