import 'package:bmcsports/providers/auth.dart';
import 'package:bmcsports/providers/user.dart';
import 'package:bmcsports/screens/home.dart';
import 'package:bmcsports/screens/login.dart';
import 'package:bmcsports/screens/register_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///This Widget act as a wrapper to incorporate various auth states in the app
///It casually listens for the authentication state changes in the firebase
///and shows appropriate screens

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: StreamBuilder(
          stream: authProvider.authInstance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: userProvider
                    .checkUserExist(authProvider.authInstance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Loading indicator
                  } else {
                    if (snapshot.data == true) {
                      return const HomeScreen();
                    } else {
                      return const RegisterDetailsScreen();
                    }
                  }
                },
              );
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}
