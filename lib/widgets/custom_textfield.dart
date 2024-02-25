import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String title;
  final bool obscureText;
  final TextInputType keyboardType;

  final bool? isEnabled;
  final bool expand;

  const CustomTextField(
    this.expand, {
    super.key,
    required this.controller,
    required this.icon,
    required this.title,
    required this.obscureText,
    required this.keyboardType,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: expand ? null : 1,
      enabled: isEnabled,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      // cursorColor: Colors.white,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.4),
        prefixIcon: Icon(
          icon,
          // color: Colors.white,
        ),
        labelText: title,
        //border: OutlineInputBorder(),
        //fillColor: Colors.white,
        filled: true,
        //labelStyle: const TextStyle(color: Colors.black45),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
              //color: Colors.black45,
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$title cannot be empty";
        }
        return null;
      },
    );
  }
}
