import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

alertDialog(BuildContext context, String msg) {
  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}

validateEmail(String email) {
  final emailRegex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return emailRegex.hasMatch(email);
}
