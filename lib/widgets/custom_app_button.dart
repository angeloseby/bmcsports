import 'package:bmcsports/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final Icon? buttonIcon;
  final bool isLoading;
  const CustomAppButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.buttonIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.scaffoldColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(double.infinity, 52.0)),
      child: isLoading
          ? const CircularProgressIndicator()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                buttonIcon ?? const SizedBox(),
              ],
            ),
    );
  }
}
