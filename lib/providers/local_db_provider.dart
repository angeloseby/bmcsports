import 'package:bmcsports/services/local_db_services.dart';
import 'package:flutter/material.dart';

class LocalDbProvider with ChangeNotifier {
  final LocalDbService _localDbService = LocalDbService();

  String? _fullName;
  String? _email;
  String? _phone;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get phone => _phone;

  /// Load user details from SharedPreferences
  Future<void> loadUserDetails() async {
    final details = await _localDbService.getUserDetails();
    _fullName = details['fullName'];
    _email = details['email'];
    _phone = details['phone'];
    notifyListeners();
  }

  /// Save and update user details in SharedPreferences
  Future<void> saveUserDetails({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    await _localDbService.saveUserDetails(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    _fullName = fullName;
    _email = email;
    _phone = phone;
    notifyListeners();
  }

  /// Clear locally stored user details
  Future<void> clearUserDetails() async {
    await _localDbService.clearUserDetails();
    _fullName = null;
    _email = null;
    _phone = null;
    notifyListeners();
  }
}
