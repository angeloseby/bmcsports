import 'dart:async';
import 'package:bmcsports/providers/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserProvider _userProvider = UserProvider();
  String? _verificationId;
  bool _isSendingOtp = false;
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _resendEnabled = false;

  String? get verificationId => _verificationId;
  bool get isSendingOtp => _isSendingOtp;
  int get secondsRemaining => _secondsRemaining;
  bool get resendEnabled => _resendEnabled;
  FirebaseAuth get authInstance => _auth;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      startTimer();
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          //implement the logic to auto login whenever the otp is sent
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failures
          print('Verification failed: ${e.code}');
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle general exceptions
      print('An error occurred: $e');
      notifyListeners();
    }
  }

  Future<void> signInWithOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: otp);
      await _auth.signInWithCredential(credential);
      _userProvider.checkUser(_auth.currentUser!.uid);
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: ${e.toString()}');
      rethrow; // Rethrow the error for handling in the UI
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        cancelTimer();
        _resendEnabled = true;
      }
      notifyListeners();
    });
    _secondsRemaining = 30;
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void setIsSendingOtp(bool value) {
    _isSendingOtp = value;
    notifyListeners();
  }

  void setResendEnabled(bool value) {
    _resendEnabled = value;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign-out error: $e');
    }
  }
}
