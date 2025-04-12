import 'package:bmcsports/providers/auth_provider.dart';
import 'package:bmcsports/screens/otp_verification_screen.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_w_name_vertical.png',
          height: 40,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              Center(
                child: Image.asset(
                  'assets/illustrations/Mobile login.gif',
                  height: size.height * 0.25,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please sign in to continue.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Phone number field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: "+91 ",
                  hintText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.primaryColor.withOpacity(0.05),
                ),
              ),
              const SizedBox(height: 16),

              // Terms & Conditions
              Row(
                children: [
                  Checkbox(
                    value: agreedToTerms,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        agreedToTerms = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Terms & Conditions",
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Send OTP Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: agreedToTerms
                      ? () async {
                          if (phoneController.text.trim().length != 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please enter a valid 10-digit phone number")),
                            );
                            return;
                          }

                          final phone = "+91${phoneController.text.trim()}";
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);

                          await authProvider.sendOtp(
                            context: context,
                            phoneNumber: phone,
                            onCodeSent: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OtpVerificationScreen(phoneNumber: phone),
                                ),
                              );
                            },
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Send OTP",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmall ? 20 : 40),
            ],
          ),
        ),
      ),
    );
  }
}
