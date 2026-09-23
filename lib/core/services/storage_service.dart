import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _baseUrlKey = "saved_base_url";

  static Future<void> saveUrl(String url) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_baseUrlKey, url);
  }

  static Future<String?> getSavedUrl() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_baseUrlKey);
  }
}
