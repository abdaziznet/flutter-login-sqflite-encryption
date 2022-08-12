import 'package:flutter/material.dart';
import 'package:flutter_login_signup_sqflite_app/Utils/helper.dart';

class GenTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintName;
  final IconData icon;
  final bool obscureText;
  final TextInputType inputType;

  const GenTextFormField(
      {Key? key,
      required this.controller,
      required this.hintName,
      required this.icon,
      this.obscureText = false,
      this.inputType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        // validator: (val) => val!.length == 0 ? '$hintName is required' : null,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return '$hintName is required';
          }
          if (hintName.toLowerCase() == "email" && !validateEmail(val)) {
            return '$hintName is not valid';
          }
          return null;
        },
        onSaved: (val) => controller.text = val!,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.green)),
          prefixIcon: Icon(icon),
          hintText: hintName,
          labelText: hintName,
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
