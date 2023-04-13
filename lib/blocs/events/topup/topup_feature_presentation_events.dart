import 'package:bevis/data/models/topup/topup_region.dart';

abstract class TopupFeaturePresentationEvent {}

class RequestLocationPermission extends TopupFeaturePresentationEvent {}

class SaveSelectedRegion extends TopupFeaturePresentationEvent {
  final TopupRegion region;

  SaveSelectedRegion(this.region);
}