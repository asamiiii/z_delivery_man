import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension NavigationHelper on BuildContext {
  //* Add Screen To widget tree Stack
  goTo(Widget screen) {
    Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  //* Remove All Screens from widget tree , and add this screen
  Future<dynamic> goReplac(Widget screen) {
    return Navigator.pushReplacement(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  void popScreen() {
    Navigator.pop(this);
  }
}
