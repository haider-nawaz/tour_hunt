import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Views/Company/company_home.dart';

import '../Controllers/auth_controller.dart';
import '../constants.dart';
import '../Views/home_view.dart';
import '../widgets/custom_textfield.dart';
import 'forgotpass_screen.dart';
import 'signup_view.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Sign in to continue",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(false,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: authController.emailController,
                      icon: Icons.email,
                      title: "Email"),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(false,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      controller: authController.passController,
                      icon: Icons.lock,
                      title: "Password"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassScreen()));
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Obx(() => authController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onTap: () async {
                        final result = await authController.signInWithEmail();
                        authController.resetFields();
                        if (result) {
                          if (authController.isTouristLoggedIn.value) {
                            Get.offAll(() => const HomeView());
                          } else {
                            Get.offAll(const CompanyHome());
                          }
                        }
                      },
                      child: primaryBtn("Sign In"),
                    )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff666666)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupView()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () async {
                  //     await makePayment();
                  //   },
                  //   child: const Text(
                  //     "Stripe",
                  //     style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
