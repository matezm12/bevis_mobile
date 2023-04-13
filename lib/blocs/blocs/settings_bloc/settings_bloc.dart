import 'package:bevis/blocs/blocs/settings_bloc/events/settings_events.dart';
import 'package:bevis/blocs/blocs/settings_bloc/states/settings_states.dart';
import 'package:bevis/data/repositories/user_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsPageState> {
  SettingsBloc({@required UserSettingsRepository userSettingsRepository})
      : _userSettingsRepository = userSettingsRepository,
        super(SettingsPageState()) {
    add(RefreshData());
  }

  final UserSettingsRepository _userSettingsRepository;

  @override
  Stream<SettingsPageState> mapEventToState(SettingsEvent event) async* {
    if (event is ChangeDefaultImageQuality) {
      try {
        await _userSettingsRepository
            .updateDefaultImageQuality(event.newQuality);
        yield state.copyWith(imageQuality: event.newQuality);
      } on Exception catch (_) {}
    } else if (event is ChangeDefaultBlockchain) {
      try {
        await _userSettingsRepository
            .updateDefaultBlockchain(event.newBlockchain);
        yield state.copyWith(blockchain: event.newBlockchain);
      } on Exception catch (_) {}
    } else if (event is RefreshData) {
      try {
        final defaultImageQuality =
            await _userSettingsRepository.getDefaultImageQuality();
        final defaultBlockchain =
            await _userSettingsRepository.getDefaultBlockchain();

        yield state.copyWith(
          imageQuality: defaultImageQuality,
          blockchain: defaultBlockchain,
        );
      } on Exception catch (_) {}
    }
  }
}
