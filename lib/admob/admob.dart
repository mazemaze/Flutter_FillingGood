import 'dart:io';

import 'package:flutter/material.dart';

class AdMobService {
  String? getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
      // 'ca-app-pub-9406495332982701/6614142752';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
      //'ca-app-pub-9406495332982701/1006592856';
    }
    return null;
  }

  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();
    return percent;
  }
}
