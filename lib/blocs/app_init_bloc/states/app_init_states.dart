import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';

abstract class AppInitState {}

class InitializingApp extends AppInitState {}

class AppInitializationSuccess extends AppInitState {
  AppInitializationSuccess(this.componentsFactory);
  
  final BevisComponentsFactory componentsFactory;
}