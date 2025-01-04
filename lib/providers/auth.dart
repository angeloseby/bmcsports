import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool _isSendingOtp = false;

  String? get verificationId => _verificationId;
  bool get isSendingOtp => _isSendingOtp;
  FirebaseAuth get authInstance => _auth;

  void setIsSendingOtp(bool value) => _isSendingOtp = value;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    _isSendingOtp = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          //implement the logic to auto login whenever the otp is sent
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failures
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _isSendingOtp = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      // Handle general exceptions
      rethrow;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: otp);
      await _auth.signInWithCredential(credential);
    } catch (e) {
      // Handle sign-in errors
      rethrow; // Rethrow the error for handling in the UI
    }
  }

  Future<void> signOut() async {
    try {
      _verificationId = null;
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
