import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../styles/color.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  bool isPassword = false,
  required Function validate,
  String? label,
  String? hintText,
  IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool autofocus = false,
  bool? enabled,
  TextStyle? labelStyle,
  Color? prefixColor,
  Color borderColor = Colors.grey,
  double borderWidth = 2,
  double borderRadius = 10,
}) {
  return TextFormField(
      autocorrect: false,
      autofocus: autofocus,
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        //! On Submit
        onSubmit;
      },
      onChanged: (String value) => onChange,
      validator: (value) {
        validate;
        return null;
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor)),
          enabledBorder: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: primaryColor, width: 2.5),
          ),
          prefixIcon: prefix == null
              ? null
              : Icon(
                  prefix,
                  color: prefixColor,
                ),
          suffixIcon: suffix == null
              ? null
              : IconButton(
                  icon: Icon(suffix),
                  onPressed: () {
                    suffixPressed;
                  },
                  color: primaryColor,
                ),
          // enabledBorder: InputBorder.none,
          // errorBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(left: 20, bottom: 11, top: 25, right: 15),
          disabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey)));
}

Future navigateTo(BuildContext context, Widget widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndReplace(BuildContext context, Widget widget) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
        (route) => false);

void showToast({required String message, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// background Toast
enum ToastStates {
  SUCCESS,
  ERROR,
  WARNING,
}

chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
