import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneHelper {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    _initialized = true;
  }

  static String getNetherlandsTime() {
    final amsterdam = tz.getLocation('Europe/Amsterdam');
    final now = tz.TZDateTime.now(amsterdam);
    return now.toString();
  }

  static DateTime getNetherlandsDateTime() {
    final amsterdam = tz.getLocation('Europe/Amsterdam');
    final now = tz.TZDateTime.now(amsterdam);
    return now;
  }

  static String getTimeByZone(String zone) {
    final location = tz.getLocation(zone);
    final now = tz.TZDateTime.now(location);
    return now.toString();
  }
}