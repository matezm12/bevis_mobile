import 'package:bevis/data/repositories/user_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUserSettingsRepository implements UserSettingsRepository {

  static String _defaultBlockchain = 'BCH';
  static String _defaultImageQuality = 'low';

  static String _imageQualityKey = 'img_quality';
  static String _blockchainKey = 'bit_coin';

  @override
  Future<void> updateDefaultImageQuality(String imageQuality) async {
    final prefs = await _getPrefs;
    prefs.setString(_imageQualityKey, imageQuality);
  }

  @override
  Future<void> updateDefaultBlockchain(String blockchain) async {
    final prefs = await _getPrefs;
    prefs.setString(_blockchainKey, blockchain);
  }

  @override
  Future<String> getDefaultImageQuality() async {
    final prefs = await _getPrefs;
    return prefs.getString(_imageQualityKey) ?? _defaultImageQuality;
  }

  @override
  Future<String> getDefaultBlockchain() async {
    final prefs = await _getPrefs;
    return prefs.getString(_blockchainKey) ?? _defaultBlockchain;
  }

  Future<SharedPreferences> get _getPrefs => SharedPreferences.getInstance();
}
