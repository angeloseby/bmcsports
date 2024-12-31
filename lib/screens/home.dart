import 'package:bmcsports/providers/auth.dart';
import 'package:bmcsports/screens/login.dart';
import 'package:bmcsports/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: CustomAppButton(
            buttonText: "Logout",
            buttonIcon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ModalRoute.withName('/'));
            },
          )),
        ),
      ),
    );
  }
}
