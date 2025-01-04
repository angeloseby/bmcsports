import 'package:bmcsports/providers/auth.dart';
import 'package:bmcsports/screens/login.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:bmcsports/widgets/custom_app_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo_w_name_vertical.png",
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: Column(
              children: [
                CarouselSlider(
                  items: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    enlargeCenterPage: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: const Text(
                          "BMC Football Turf",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: CustomAppButton(
                          buttonText: "Logout",
                          buttonIcon: const Icon(Icons.logout),
                          onPressed: () {
                            context.read<AuthProvider>().signOut();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Add more content here if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
