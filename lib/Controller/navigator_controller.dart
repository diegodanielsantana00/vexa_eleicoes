import 'package:flutter/material.dart';

class NavigatorController {
  navigatorToNoReturn(context, dynamic screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false);
  }

  navigatorToReturn(context, dynamic screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  navigatorToNoReturnNoAnimated(context, dynamic screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: Duration.zero,
      ),
    );
  }

  navigatorBack(context) {
    Navigator.of(context).pop();
  }

}
