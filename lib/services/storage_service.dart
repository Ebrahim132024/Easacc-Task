import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("web_url", url);
  }

  static Future<String?> loadUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("web_url");
  }
}
