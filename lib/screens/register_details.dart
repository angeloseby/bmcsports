import 'package:bmcsports/utils/app_colors.dart';
import 'package:bmcsports/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "We are all set!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const Text(
                    "Just complete the details below",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  CustomTextField(textEditingController: _nameController)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
