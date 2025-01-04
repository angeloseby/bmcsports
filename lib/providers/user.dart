import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestoreReference = FirebaseFirestore.instance;

  Future<bool> checkUserExist(String userId) async {
    final userDoc = _firestoreReference.collection('users').doc(userId);

    try {
      DocumentSnapshot userDocument = await userDoc.get();
      if (!userDocument.exists) {
        //if user doesnot exist it creates the initial document
        //for user and returns false
        createInitalUser(userId);
        print('User document created successfully.');

        return checkDetailsFilled(userId);
      } else {
        // return true if user exist
        print('User document already exists.');
        return checkDetailsFilled(userId);
      }
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  Future<bool> checkDetailsFilled(String userId) async {
    final userDoc = _firestoreReference.collection('users').doc(userId);
    final DocumentSnapshot<Map<String, dynamic>> userDetails =
        await userDoc.get();
    try {
      return userDetails.data()?['userDetailsEntered'];
    } catch (e) {
      // TODO
      rethrow;
    }
  }

  Future<void> createInitalUser(String userId) async {
    final userDoc = _firestoreReference.collection('users').doc(userId);
    try {
      await userDoc.set({
        // Add other user data here
        'createdAt': FieldValue.serverTimestamp(),
        'userDetailsEntered': false
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setUserName(String name, String userId) async {
    final userDoc = _firestoreReference.collection('users').doc(userId);
    try {
      await userDoc.update({'userDetailsEntered': true, 'fullName': name});
    } catch (e) {
      rethrow;
    }
  }
}
