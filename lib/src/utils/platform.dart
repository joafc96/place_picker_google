import 'package:flutter/foundation.dart';

class Platform {
  static bool get isWeb => kIsWeb;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isiOS => defaultTargetPlatform == TargetPlatform.iOS;
}
