import 'package:ecommerce/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

Widget authTextField(String hint, TextInputType type, bool obsecure,
    TextEditingController controller) {
  return TextFormField(
    style: const TextStyle(color: Colors.white, fontFamily: "poppinslight"),
    controller: controller,
    validator: (input) {
      if (input == null || input.isEmpty) {
        return obsecure ? "Password can't be null" : "email can't be null";
      }
      if (obsecure) {
        if (!input.isValidPassword()) {
          return "Password length must be at least 6 characters";
        }
      } else {
        if (!input.isValidEmail()) {
          return "Check you email";
        }
      }

      return null;
    },
    obscureText: obsecure,
    keyboardType: type,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(179, 179, 179, 1),
          fontFamily: "poppinslight",
        ),
        border: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5))),
  );
}
