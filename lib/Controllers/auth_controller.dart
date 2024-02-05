import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Views/home_view.dart';
import 'package:tour_hunt/auth/signin_view.dart';

import '../../constants.dart';
import '../auth/verify_email.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();

  final enableSubmitBtn = false.obs;

  var countryCode = "";

  final checkBox = false.obs;
  bool isCompany = false;

  final isTouristLoggedIn = true.obs;

  final formKey = GlobalKey<FormState>();
  final emailSent = false.obs;
  final isEmailVerified = false.obs;
  Timer? timer;

  final companyTitle = "".obs;

  //a list that will hold the current logged in user

  void prep() {
    sendVerificationEmail();
    print("verfication started");
    //super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      FirebaseAuth.instance.currentUser!.reload();

      // setState(() {
      isEmailVerified.value = FirebaseAuth.instance.currentUser!.emailVerified;
      // });

      if (isEmailVerified.value) {
        resetFields();
        print("verified");
        timer.cancel();
        // Get.offAll(const HomeView());
      }
    });
  }

  void sendVerificationEmail() {
    // signInwithEmail();
    print(FirebaseAuth.instance.currentUser!.email);
    FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then((value) {
          emailSent.value = true;
          prep();
          // Get.snackbar("Success", "Verification email sent",
          //     snackPosition: SnackPosition.TOP,
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white);
        })
        .catchError((onError) {})
        .catchError((onError) => null);
  }

  void resetFields() {
    emailController.text = "";
    passController.text = "";
    phoneController.text = "";
    dobController.text = "";
    checkBox.value = false;
    isLoading.value = false;
    firstNameController.text = "";
    lastNameController.text = "";
    addressController.text = "";
  }

  void enableSubBtn() {
    //if all of the fields are filled and the checkbox is checked then enable the submit button
    if (emailController.text.toString().trim().isNotEmpty &&
        passController.text.toString().trim().isNotEmpty &&
        phoneController.text.toString().trim().isNotEmpty &&
        dobController.text.toString().trim().isNotEmpty &&
        firstNameController.text.toString().trim().isNotEmpty &&
        lastNameController.text.toString().trim().isNotEmpty &&
        checkBox.value) {
      enableSubmitBtn.value = true;
    } else {
      enableSubmitBtn.value = false;
    }
  }

  void sendForgetPasswordEmail() async {
    if (emailController.text.toString().trim().isEmpty) {
      customSnack("Please enter your email address", true, "Error");

      return;
    }
    isLoading.value = true;

    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.toString().trim())
        .then((value) {
      customSnack(
          "Password reset email sent to ${emailController.text.toString().trim()}",
          false,
          "Success");
    }).catchError((onError) {
      //customSnack(onError.toString(), true, "Error");
      isLoading.value = false;
    });
    isLoading.value = false;
    emailController.text = "";
  }

  bool validateInputs(bool isCompany) {
    print("in validate");
    if (isCompany) {
      print("in company");

      if (emailController.text.toString().trim().isEmpty) {
        customSnack("Please enter your email address", true, "Error");
        return false;
      }
      if (passController.text.toString().trim().isEmpty) {
        customSnack("Please enter your password", true, "Error");
        return false;
      }
      if (phoneController.text.toString().trim().isEmpty) {
        customSnack("Please enter your phone number", true, "Error");
        return false;
      }
      if (firstNameController.text.toString().trim().isEmpty) {
        customSnack("Please enter your first name", true, "Error");
        return false;
      }
      if (addressController.text.toString().trim().isEmpty) {
        customSnack("Please enter Address", true, "Error");
        return false;
      }
    } else {
      if (emailController.text.toString().trim().isEmpty) {
        customSnack("Please enter your email address", true, "Error");
        return false;
      }
      if (passController.text.toString().trim().isEmpty) {
        customSnack("Please enter your password", true, "Error");
        return false;
      }
      if (phoneController.text.toString().trim().isEmpty) {
        customSnack("Please enter your phone number", true, "Error");
        return false;
      }
      if (firstNameController.text.toString().trim().isEmpty) {
        customSnack("Please enter your first name", true, "Error");
        return false;
      }
      if (lastNameController.text.toString().trim().isEmpty) {
        customSnack("Please enter your last name", true, "Error");
        return false;
      }
      if (dobController.text.toString().trim().isEmpty) {
        customSnack("Please enter your date of birth", true, "Error");
        return false;
      }
    }

    //password validation, 1 capital, 1 number, 1 special character
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])')
        .hasMatch(passController.text.toString().trim())) {
      customSnack(
          "Password must contain at least 1 capital letter, 1 number and 1 special character",
          true,
          "Error");
      return false;
    }
    return true;
  }

  Future<bool> creatAndUploadUser(bool isCompany) async {
    print(CountryCode.fromDialCode(countryCode).name);

    if (!validateInputs(isCompany)) {
      return false;
    }
    isLoading.value = true;

    DatabaseReference ref = isCompany
        ? FirebaseDatabase.instance.ref("newregisterations")
        : FirebaseDatabase.instance.ref("tourists");

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passController.text.toString().trim())
        .then((value) async {
      print("User Created");
      //upload the user in the instructors collection

      await ref
          .child(
            FirebaseAuth.instance.currentUser!.uid,
          )
          .set(
            isCompany
                ? {
                    "email": emailController.text.toString().trim(),
                    "phone": phoneController.text.toString().trim(),
                    // "dob": dobController.text.toString().trim(),
                    // "fName": firstNameController.text.toString().trim(),
                    // "lName": lastNameController.text.toString().trim(),
                    "name": firstNameController.text.toString().trim(),
                    // "uid": FirebaseAuth.instance.currentUser!.uid,
                    "password": passController.text.toString().trim(),
                    "address": addressController.text.toString().trim(),
                    "country": CountryCode.fromDialCode(countryCode).name,
                  }
                : {
                    "email": emailController.text.toString().trim(),
                    "phone": phoneController.text.toString().trim(),
                    "dob": dobController.text.toString().trim(),
                    "fname": firstNameController.text.toString().trim(),
                    "lname": lastNameController.text.toString().trim(),
                    //"uid": FirebaseAuth.instance.currentUser!.uid,
                    "password": passController.text.toString().trim(),
                    "country": CountryCode.fromDialCode(countryCode).name,
                  },
          )
          .then((value) async {
        print("User Uploaded");
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.toString().trim(),
          password: passController.text.toString().trim(),
        )
            .then((value) async {
          // prep();
          // //sign in the user
          resetFields();
          Get.to(const SignInView());
        });
        // resetFields();

        print("User Signed In");
        isLoading.value = false;
        return true;
      });
    }).catchError((onError) {
      isLoading.value = false;

      //make the error user friendly
      if (onError.toString().contains("email-already-in-use")) {
        customSnack("Email already in use", true, "Error");
      } else if (onError.toString().contains("invalid-email")) {
        customSnack("Invalid Email", true, "Error");
      } else {
        customSnack(onError.toString(), true, "Error");
      }
      print("Error creating user: $onError");
    });
    return false;
  }

  Future<bool> signInWithEmail() async {
    if (emailController.text.toString().trim().isEmpty) {
      customSnack("Please enter your email address", true, "Error");
      return false;
    }
    if (passController.text.toString().trim().isEmpty) {
      customSnack("Please enter your password", true, "Error");
      return false;
    }

    isLoading.value = true;

    //

    final ref = FirebaseDatabase.instance.ref("companies");

    //check if the email and password exists and matches in the newregisterations collection
    final snapshot = await ref.get();

    if (snapshot.exists) {
      bool result = false;
      final data = snapshot.value;

      (data as Map<dynamic, dynamic>).forEach((key, value) {
        if (value['email'] == emailController.text.toString().trim() &&
            value['password'] == passController.text.toString().trim()) {
          print("user found in newregisterations");
          companyTitle.value = value['name'];

          isTouristLoggedIn.value = false;
        }
      });

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.toString().trim(),
        password: passController.text.toString().trim(),
      )
          .then((value) {
        print("User Signed In in newregisterations");
        isLoading.value = false;
        result = true;
      }).catchError((onError) {
        isLoading.value = false;
        //make the error user friendly
        if (onError.toString().contains("user-not-found")) {
          customSnack("User not found", true, "Error");
        } else if (onError.toString().contains("wrong-password")) {
          customSnack("Wrong password", true, "Error");
        } else {
          customSnack("Invalid Login or your account is not approved yet.",
              true, "Error");
        }
        print("Error signing in: $onError");
        result = false;
      });

      return result;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.toString().trim(),
        password: passController.text.toString().trim(),
      );

      print("User Signed In");

      // isLoading.value = false;
      //await Get.find<UserController>().getCurrentUserDetails();
      return true;
    } catch (e) {
      if (e.toString().contains("user-not-found")) {
        customSnack("User not found", true, "Error");
      } else if (e.toString().contains("wrong-password")) {
        customSnack("Wrong password", true, "Error");
      } else {
        customSnack("Invalid Login Credentials.", true, "Error");
      }
      print("Error signing in: $e");
      isLoading.value = false;
      return false;
    }
  }
}
