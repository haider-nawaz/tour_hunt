import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';
import 'signin_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: authController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CupertinoSlidingSegmentedControl(
                        children: const {
                          0: Text("Tourist"),
                          1: Text("Company"),
                        },
                        groupValue: authController.isCompany ? 1 : 0,
                        onValueChanged: (value) {
                          setState(() {
                            authController.isCompany = value == 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    !authController.isCompany
                        ? const Text(
                            "Tourist Registration",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )
                        : const Text(
                            "Company Registration",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                    const Text(
                      "Create account and complete your profile.",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!authController.isCompany) ...[
                      CustomTextField(false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: authController.firstNameController,
                          icon: Icons.person,
                          title: "First Name"),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: authController.lastNameController,
                          icon: Icons.person,
                          title: "Last Name"),
                    ],
                    if (authController.isCompany) ...[
                      CustomTextField(false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: authController.firstNameController,
                          icon: Icons.person,
                          title: "Company Name"),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: authController.addressController,
                          icon: Icons.location_city,
                          title: "Address"),
                    ],
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(false,
                        obscureText: false,
                        keyboardType: TextInputType.text,
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: CountryCodePicker(
                              onChanged: updateNumber,
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              // initialSelection: 'PK',
                              favorite: const ['+92', 'PK'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: CustomTextField(
                            false,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            controller: authController.phoneController,
                            icon: Icons.phone,
                            title: "Phone",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!authController.isCompany)
                      GestureDetector(
                        onTap: () {
                          //open android date picker

                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.year,
                          ).then((value) {
                            if (value != null) {
                              authController.dobController.text =
                                  value.toString().substring(0, 10);
                            }
                          });
                        },
                        child: CustomTextField(
                          false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: authController.dobController,
                          icon: Icons.date_range,
                          title: "Date of Birth",
                          isEnabled: false,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                !authController.isCompany
                    ? Obx(
                        () => authController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : GestureDetector(
                                onTap: () {
                                  // if (authController.enableSubmitBtn.value) {
                                  authController.creatAndUploadUser(false);
                                  // }
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 60,
                                  child: const Center(
                                    child: Text(
                                      "Sign Up as a Tourist",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                      )
                    : Obx(
                        () => authController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : GestureDetector(
                                onTap: () {
                                  // if (authController.enableSubmitBtn.value) {
                                  authController.creatAndUploadUser(true);
                                  //}
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 60,
                                  child: const Center(
                                    child: Text(
                                      "Sign Up as a Company",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
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
                                builder: (context) => const SignInView()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Row term(AuthController authController, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => Checkbox(
            value: authController.checkBox.value,
            onChanged: (value) {
              authController.checkBox.value = value!;
              // if (value) {
              authController.enableSubBtn();
              //}
            },
            shape: const CircleBorder(),
          ),
        ),
        const Text(
          "I agree to the",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () {
            //open a dialog with terms and conditions
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: const Color(0xffffffff),
                    //shadowColor: Colors.white,
                    title: const Text("Terms and Conditions"),
                    content: const Text("This is the terms and conditions"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"))
                    ],
                  );
                });
          },
          child: const Text(
            " Terms and Conditions.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void updateNumber(CountryCode value) {
    final authController = Get.find<AuthController>();
    authController.countryCode = value.dialCode.toString();
    print(authController.countryCode);
  }
}
