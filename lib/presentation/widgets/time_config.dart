import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../core/utils/string.dart';

class TimeZoneHelper {
  static bool _initialized = false;
  static late tz.Location amsterdam;

  static Future<void> initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    amsterdam = tz.getLocation(GetStorage().read(timezoneKey)??'Europe/Amsterdam');
    _initialized = true;
  }

  /// Returns current Netherlands time as normal DateTime (NOT TZDateTime)
  static DateTime nowNetherlands() {
    final now = tz.TZDateTime.now(amsterdam);
    return DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second, now.millisecond);
  }

  /// Convert server UTC timestamp (e.g. "2025-12-06T19:17:21.685Z") → Netherlands time
  static DateTime fromUtcString(String utcIsoString) {
    final utc = DateTime.parse(utcIsoString).toUtc();
    final ams = tz.TZDateTime.from(utc, amsterdam);
    return DateTime(ams.year, ams.month, ams.day, ams.hour, ams.minute, ams.second, ams.millisecond);
  }

  /// For relative time: "just now", "5m ago", etc.
  static String formatRelative(DateTime netherlandsTime) {
    final now = nowNetherlands();
    final diff = now.difference(netherlandsTime);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${netherlandsTime.day}/${netherlandsTime.month} ${netherlandsTime.hour.toString().padLeft(2,'0')}:${netherlandsTime.minute.toString().padLeft(2,'0')}';
  }
}