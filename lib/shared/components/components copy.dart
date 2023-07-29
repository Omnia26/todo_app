// ignore_for_file: file_names, prefer_const_constructors, avoid_print, sort_child_properties_last

import 'package:flutter/material.dart';

Widget defaultButton({
  required double width,
  required Color uesdcolor,
  dynamic function, //dynamic
  required String text,
  required double raddius,
  bool isuppercase = true,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function, //
        child: Text(
          isuppercase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: uesdcolor,
        borderRadius: BorderRadius.circular(
          raddius,
        ),
      ),
    );

Widget defaultformfield({
  required TextEditingController emailController,
  required TextInputType type,
  dynamic onsubmit,
  dynamic onchange,
  required dynamic validate,
  String? label,
  IconData? icoon,
  IconData? suffix,
   bool ispass = false,
   dynamic suffixpressed,
}) =>
    TextFormField(
      obscureText: ispass,
      validator: validate,
      controller: emailController,
      keyboardType: type,
      onFieldSubmitted: onsubmit,
      onChanged: onchange,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icoon,
        ),
        suffixIcon: suffix!=null ? IconButton(
          icon: Icon(
            suffix,
          ),
          onPressed: suffixpressed,
        ):null,
        border: OutlineInputBorder(),
      ),
    );
