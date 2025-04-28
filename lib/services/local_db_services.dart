import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  static const String _keyFullName = 'userFullName';
  static const String _keyEmail = 'userEmail';
  static const String _keyPhone = 'userPhone';

  /// Saves user details (full name, email, and phone number) to local storage.
  Future<void> saveUserDetails({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPhone, phone);
  }

  /// Optionally, you can also provide a method to retrieve user details.
  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'fullName': prefs.getString(_keyFullName),
      'email': prefs.getString(_keyEmail),
      'phone': prefs.getString(_keyPhone),
    };
  }

  /// Checks whether all user details (fullName, email, phone) are set.
  Future<bool> areUserDetailsSet() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString(_keyFullName);
    final email = prefs.getString(_keyEmail);
    final phone = prefs.getString(_keyPhone);

    return fullName != null && email != null && phone != null;
  }
}
