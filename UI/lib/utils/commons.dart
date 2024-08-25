import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Common function for entire app

class Commons {

  // Get the width of an input field
  static double getInputFieldWidth(BuildContext context) {
    // default - 40% of screen width
    double fieldWidth = MediaQuery.of(context).size.width * 0.4; 
    // 40% of screen width for web application
    if (kIsWeb) {
      fieldWidth = MediaQuery.of(context).size.width * 0.4;
    } 
    // 80% of screen width for IOS and Android
    else if (Platform.isIOS || Platform.isAndroid) {
      fieldWidth = MediaQuery.of(context).size.width * 0.8;
    }
    return fieldWidth;
  }
}
