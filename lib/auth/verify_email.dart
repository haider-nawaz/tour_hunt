import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/auth/signin_view.dart';

import '../Controllers/auth_controller.dart';
import '../Views/home_view.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activate your Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/verify.png",
              height: 250,
              width: 250,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Thank you. Please check your email and finish setting up your account.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Obx(
              () => GestureDetector(
                onTap: () {
                  if (authController.isEmailVerified.value) {
                    Get.to(() => const SignInView());
                  }
                },
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: authController.isEmailVerified.value
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 60,
                  child: const Center(
                    child: Text(
                      "Let's Go!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
