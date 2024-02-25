import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/auth_controller.dart';
import '../constants.dart';
import '../widgets/custom_textfield.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Enter your email address and we will send you a link to reset your password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(false,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                controller: authController.emailController,
                icon: Icons.email,
                title: "Email"),
            const SizedBox(
              height: 50,
            ),
            Obx(() => authController.isLoading.value
                ? Center(child: const CircularProgressIndicator())
                : GestureDetector(
                    onTap: () {
                      authController.sendForgetPasswordEmail();
                    },
                    child: primaryBtn("SEND"),
                  ))
          ],
        ),
      ),
    );
  }
}
