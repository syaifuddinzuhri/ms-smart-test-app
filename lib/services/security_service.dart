import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:screen_protector/screen_protector.dart';

class SecurityService {
  static Future<void> startSecureMode() async {
    await ScreenProtector.preventScreenshotOn();
    await startKioskMode();
  }

  static Future<void> stopSecureMode() async {
    await stopKioskMode();
    await ScreenProtector.preventScreenshotOff();
  }
}