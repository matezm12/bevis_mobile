import 'package:bevis/blocs/app_init_bloc/events/app_init_events.dart';
import 'package:bevis/blocs/app_init_bloc/states/app_init_states.dart';
import 'package:bevis/factory_producers/bevis_components_factory_producer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppInitBloc extends Bloc<AppInitEvent, AppInitState> {
  AppInitBloc(
      {@required BevisComponentsFactoryProducer bevisComponentsFactoryProducer})
      : _bevisComponentsFactoryProducer = bevisComponentsFactoryProducer,
        super(InitializingApp());

  final BevisComponentsFactoryProducer _bevisComponentsFactoryProducer;

  @override
  Stream<AppInitState> mapEventToState(AppInitEvent event) async* {
    if (event is InitAppEvent) {
      yield InitializingApp();

      final factory = _bevisComponentsFactoryProducer.getFactory();
      yield AppInitializationSuccess(factory);
    }
  }
}
