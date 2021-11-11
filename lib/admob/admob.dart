import 'dart:io';

import 'package:flutter/material.dart';

class AdMobService {
  String? getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9406495332982701/6614142752';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9406495332982701/3512502542';
    }
    return null;
  }

  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();
    return percent;
  }
}
