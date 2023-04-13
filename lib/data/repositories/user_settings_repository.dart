abstract class UserSettingsRepository {
  Future<void> updateDefaultImageQuality(String imageQuality);
  Future<void> updateDefaultBlockchain(String blockchain);

  Future<String> getDefaultImageQuality();
  Future<String> getDefaultBlockchain();
}