import 'dart:io';

import 'package:flutter/widgets.dart';

class AppAnimationCurves {
  static final Curve defaultCurve = Platform.isIOS
      ? Curves.easeInOutBack
      : Curves.easeInOut;
  static final Curve androidCurve = Curves.easeInOut;
  static final Curve iosCurve = Curves.easeInOutBack;
}
