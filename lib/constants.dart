import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

const key =
    "sk_test_51OM8N5Ig1AmjwSTW5SJYgMg35jeBS7x1mDpkPQw0Jxm2ZR117t6f498bqgNhVaKATycBYdCSxbGNlH1Q37q0xcGB00LDkLm4lI";

Map<String, dynamic>? paymentIntent;

Widget primaryBtn(String text) {
  return Container(
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(15),
    ),
    height: 60,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  );
}

void customSnack(String text, bool isError, String title) {
  Get.snackbar(
    title,
    text,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? Colors.red : Colors.green,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
  );
}

String convertTimetoDays(String dateTime, {bool arrival = false}) {
  //2023-09-04T13:42
  //convert this to days

  final date = DateTime.parse(dateTime);
  // print(date);
  final now = DateTime.now();
  final difference = date.difference(now).inDays;
  // print("Difference is $difference");

  if (difference < 0) {
    return "Expired";
  } else if (difference == 0) {
    return "Today";
  } else if (difference == 1) {
    return "Tomorrow";
  } else {
    return arrival
        ? "arrival in $difference days"
        : "leaves in $difference days";
  }
}

String convertTimetoDaysMonthsYears(
    DateTime departureDate, DateTime arrivalDate) {
  //calculate the difference between the two dates in days or months or years
  final difference = arrivalDate.difference(departureDate).inDays;

  // if (difference.inDays > 1 && difference.inDays < 30) {
  //   return "${difference.inDays} days";
  // } else if (difference.inDays > 30 && difference.inDays < 365) {
  //   return "${(difference.inDays / 30).floor()} months";
  // } else if (difference.inDays >= 365) {
  //   return "${(difference.inDays / 365).round()} years";
  // }
  return (difference + 1).toString();
}
