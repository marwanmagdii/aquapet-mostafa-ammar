import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/reminder_tank.dart';

/// Local notification wrapper for food run-out alerts and feeding schedules.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  void Function(String? productId)? onNotificationTap;

  Future<void> init({void Function(String? productId)? onTap}) async {
    onNotificationTap = onTap;
    if (_initialized || kIsWeb) return;

    tz.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (response) {
          onNotificationTap?.call(response.payload);
        },
      );
      _initialized = true;
    } catch (_) {
      // Safe fallback in headless/test environments.
    }
  }

  Future<void> showInstant({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized || kIsWeb) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'aquapet_reminders',
        'AquaPet Reminders',
        channelDescription: 'Fish food run-out, feeding & tank care alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.show(id, title, body, details, payload: payload);
    } catch (_) {}
  }

  Future<void> scheduleFoodRunOutNotifications({
    required ReminderModel reminder,
    required DateTime now,
    required bool isArabic,
  }) async {
    if (!_initialized || kIsWeb || !reminder.isEnabled) return;
    final daysLeft = reminder.daysLeftAt(now);
    final offsets = <int>[daysLeft - 5, daysLeft - 1, daysLeft];

    for (var i = 0; i < offsets.length; i++) {
      final offsetDays = offsets[i];
      if (offsetDays < 0) continue;
      final scheduledDate = tz.TZDateTime.from(
        now.add(Duration(days: offsetDays, minutes: 1)),
        tz.local,
      );
      final title = isArabic
          ? 'تذكير طعام الأسماك: ${reminder.titleAr}'
          : 'Fish Food Alert: ${reminder.titleEn}';
      final body = switch (i) {
        0 => isArabic
            ? 'متبقي حوالي ٥ أيام قبل نفاد الطعام. اضغط لإعادة الطلب.'
            : 'About 5 days of food left. Tap to reorder.',
        1 => isArabic
            ? 'متبقي يوم واحد فقط قبل نفاد الطعام!'
            : 'Only 1 day of food left! Tap to reorder.',
        _ => isArabic
            ? 'نفد طعام الأسماك اليوم. أعد الطلب الآن.'
            : 'Your fish food runs out today. Tap to reorder.',
      };

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'aquapet_food',
          'Food Reorder Reminders',
          channelDescription: 'Alerts 5 days, 1 day, and on food run-out day',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      try {
        await _plugin.zonedSchedule(
          reminder.id.hashCode + i,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: reminder.productId,
        );
      } catch (_) {}
    }
  }
}
