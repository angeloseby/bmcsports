import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  Future<void> checkUser(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      DocumentSnapshot documentSnapshot = await userDoc.get();

      if (!documentSnapshot.exists) {
        await userDoc.set({
          // Add other user data here
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('User document created successfully.');
      } else {
        print('User document already exists.');
      }
    } catch (e) {
      print('Error creating user document: $e');
    }
  }
}
