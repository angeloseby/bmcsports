import 'package:bmcsports/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;
  bool isOtpSent = false;
  bool isLoading = false;

  Future<void> sendOtp({
    required String phoneNumber,
    required BuildContext context,
    required VoidCallback onCodeSent,
  }) async {
    isLoading = true;
    notifyListeners();

    await _authService.sendOtp(
      phoneNumber,
      (verificationId) {
        _verificationId = verificationId;
        isOtpSent = true;
        isLoading = false;
        notifyListeners();
        onCodeSent();
      },
      (error) {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
        notifyListeners();
      },
    );
  }

  Future<void> verifyOtp({
    required String otp,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    if (_verificationId == null) return;

    isLoading = true;
    notifyListeners();

    await _authService.verifyOtp(
      verificationId: _verificationId!,
      otp: otp,
      onSuccess: () async {
        await _handleUserRouting(context);
        isLoading = false;
        notifyListeners();
        onSuccess();
      },
      onError: (error) {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
        notifyListeners();
      },
    );
  }

  Future<void> _handleUserRouting(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = _firestore.collection('customers').doc(currentUser.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Create new user with detailsEntered = false and createdAt
      await userDoc.set({
        'phoneNumber': currentUser.phoneNumber,
        'detailsEntered': false,
        'createdBy': 'app',
        'createdAt': FieldValue.serverTimestamp(), // <-- Added this line
      });

      // Navigate to details entry screen
      Navigator.pushReplacementNamed(context, '/enterDetails');
    } else {
      final data = docSnapshot.data()!;
      final detailsEntered = data['detailsEntered'] ?? false;

      if (detailsEntered) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/enterDetails');
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // or your login route
  }
}
