import 'package:bmcsports/providers/auth.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:bmcsports/widgets/custom_app_button.dart';
import 'package:bmcsports/widgets/custom_phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            reverse: true,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AuthProvider>(
                builder: (context, providerSnapshot, child) {
                  if (providerSnapshot.verificationId == null) {
                    return PhoneNumberDetails(
                      formKey: _formKey,
                      phoneNumberController: _phoneNumberController,
                    );
                  } else {
                    return OTPDetails(
                      phoneNumberController: _phoneNumberController,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OTPDetails extends StatelessWidget {
  final TextEditingController phoneNumberController;
  const OTPDetails({
    super.key,
    required this.phoneNumberController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/illustrations/Enter OTP.gif',
          width: MediaQuery.of(context).size.width * 0.75,
        ),
        const Text(
          "Verify the OTP",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          "Please enter the OTP sent to\n+91 ${phoneNumberController.text}",
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 26.0,
        ),
        OtpPinField(
          fieldWidth: 30,
          maxLength: 6,
          showCursor: false,
          onSubmit: (value) async {
            try {
              await context.read<AuthProvider>().verifyOTP(value);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.toString(),
                  ),
                ),
              );
            }
          },
          onChange: (value) {},
          otpPinFieldStyle: const OtpPinFieldStyle(
            hintTextColor: Colors.grey,
            activeFieldBorderColor: AppColors.primaryColor,
            filledFieldBorderColor: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        // const Center(
        //   child: Text.rich(
        //     textAlign: TextAlign.center,
        //     TextSpan(
        //       text: "Didn't Receive OTP?",
        //       style: TextStyle(
        //         fontSize: 12.0,
        //       ),
        //       children: [
        //         TextSpan(
        //           text: "\nResend in ",
        //           style: TextStyle(
        //             color: AppColors.primaryColor,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         TextSpan(
        //           text: "0 seconds",
        //           style: TextStyle(
        //             color: AppColors.primaryColor,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class PhoneNumberDetails extends StatelessWidget {
  const PhoneNumberDetails({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController phoneNumberController,
  })  : _formKey = formKey,
        _phoneNumberController = phoneNumberController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/illustrations/Sign up.gif',
              width: MediaQuery.of(context).size.width * 0.75,
            ),
          ),
          const Text(
            "Hi There!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
            ),
          ),
          const Text(
            "Login in to continue",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text(
            "Please enter a 10-digit valid mobile \nnumber to receive OTP",
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 26.0,
          ),
          PhoneNumberField(
            phoneNumberController: _phoneNumberController,
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Center(
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: "By proceeding, you agree to the ",
                style: TextStyle(
                  fontSize: 12.0,
                ),
                children: [
                  TextSpan(
                    text: "\nTerms and Conditions ",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "and "),
                  TextSpan(
                    text: "Privacy Policy.",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return CustomAppButton(
                onPressed: authProvider.isSendingOtp
                    ? null
                    : () async {
                        authProvider.setIsSendingOtp(true);
                        if (_formKey.currentState!.validate()) {
                          try {
                            await authProvider
                                .verifyPhoneNumber(_phoneNumberController.text);
                            authProvider.setIsSendingOtp(false);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to send OTP'),
                              ),
                            );
                            authProvider.setIsSendingOtp(false);
                          }
                        }
                      },
                buttonText: "Send OTP",
                buttonIcon: const Icon(Icons.arrow_forward),
                isLoading: authProvider.isSendingOtp,
              );
            },
          ),
        ],
      ),
    );
  }
}
