import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyAccountID = 'accountID';
  static const _keyContact = 'contact';
  static const _keyUsername = 'username';
  static const _keyToken = 'token';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAccountID(int accountID) async =>
      await _preferences.setInt(_keyAccountID, accountID);

  static int? getAccountID() => _preferences.getInt(_keyAccountID);

  static Future setContact(String contact) async =>
      await _preferences.setString(_keyContact, contact);

  static String? getContact() => _preferences.getString(_keyContact);

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String? getUsername() => _preferences.getString(_keyUsername);

  static Future setToken(String token) async =>
      await _preferences.setString(_keyToken, token);

  static String? getToken() => _preferences.getString(_keyToken);
}
