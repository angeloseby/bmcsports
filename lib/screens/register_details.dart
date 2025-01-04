import 'package:bmcsports/providers/auth.dart';
import 'package:bmcsports/providers/user.dart';
import 'package:bmcsports/screens/home.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:bmcsports/widgets/custom_app_button.dart';
import 'package:bmcsports/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterDetailsScreen extends StatelessWidget {
  const RegisterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo_w_name_vertical.png",
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.start,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/illustrations/Mobile login.gif',
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
                  ),
                  const Text(
                    "We are all set!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                  const Text(
                    "Just complete the details below",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  CustomTextField(textEditingController: _nameController),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Consumer2<UserProvider, AuthProvider>(
                    builder: (BuildContext context, UserProvider userProvider,
                        AuthProvider authProvider, Widget? child) {
                      return CustomAppButton(
                        buttonText: "Continue",
                        buttonIcon: const Icon(
                          Icons.arrow_forward,
                        ),
                        onPressed: () async {
                          if (_nameController.text.isNotEmpty &&
                              _nameController.text.length >= 3) {
                            try {
                              await userProvider.setUserName(
                                  _nameController.text,
                                  authProvider.authInstance.currentUser!.uid);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return const HomeScreen();
                                }),
                                ModalRoute.withName('/'),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to send OTP'),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
