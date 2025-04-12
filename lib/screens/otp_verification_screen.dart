import 'package:bmcsports/providers/auth_provider.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // listen: true

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              "Enter the OTP sent to",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              widget.phoneNumber,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 40),

            // OTP input
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.primaryColor.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: 30),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        final code = otpController.text.trim();
                        if (code.isEmpty || code.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a valid 6-digit OTP"),
                            ),
                          );
                          return;
                        }

                        await authProvider.verifyOtp(
                          context: context,
                          otp: code,
                          onSuccess: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login successful")),
                            );
                            // ✅ Navigation handled inside the provider
                          },
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Verify",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
