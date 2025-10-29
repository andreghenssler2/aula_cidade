import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String keyUsarFirebase = 'usarFirebase';

  Future<void> setUsarFirebase(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyUsarFirebase, valor);
  }

  Future<bool> getUsarFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyUsarFirebase) ?? false;
  }
}
