import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<String> getUserType() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("userType") ?? "";
  }

  static Future setUID(String UID) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("UID", UID);
  }

  static Future<String> getUID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("UID") ?? "no uid";
  }
}
