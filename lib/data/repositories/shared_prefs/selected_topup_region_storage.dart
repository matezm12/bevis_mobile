import 'dart:convert';

import 'package:bevis/data/models/topup/topup_region.dart';
import 'package:bevis/utils/constants/storage/selected_topup_region_storage_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedTopupRegionStorage {
  static Future<bool> saveSelectedTopupRegion(TopupRegion region) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.setString(
        SelectedTopupRegionConstants.SelectedTopupRegion,
        jsonEncode(region.toJson()));
  }

  static Future<TopupRegion> getSelectedTopupRegion() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final json =
        sharedPrefs.getString(SelectedTopupRegionConstants.SelectedTopupRegion);
    if (json != null) {
      return TopupRegion.fromJson(jsonDecode(json));
    }
    
    return null;
  }
}
