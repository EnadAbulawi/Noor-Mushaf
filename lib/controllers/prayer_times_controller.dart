import 'dart:async';
import 'dart:developer';

import 'package:alfurqan/features/athanPlayer.dart';
import 'package:alfurqan/models/prayer_time_model.dart';
import 'package:alfurqan/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'settings_controller.dart';

class PrayerTimesController extends GetxController {
  var prayerTimes = Rxn<PrayerTimes>();
  var location = "جاري تحديد الموقع...".obs;
  var nextPrayer = "".obs;
  var nextPrayerTime = "".obs;
  var isLoading = false.obs;
  var locationPermissionDenied = false.obs;
  var isLocationServiceEnabled = false.obs;

  @override
  void onInit() {
    checkLocationPermission();
    fetchPrayerTimes(); // جلب أوقات الصلاة
    startPrayerTimeMonitoring(); // بدء مراقبة أوقات الصلاة
    super.onInit();
  }

  /// 🔹 التحقق من حالة خدمات الموقع
  Future<void> checkLocationServiceStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationServiceEnabled.value = serviceEnabled;

    if (!serviceEnabled) {
      locationPermissionDenied(false);
    } else {
      fetchPrayerTimes();
    }
  }

  // تدفق لتشغيل الأذان والإشعارات تلقائيًا
  void startPrayerTimeMonitoring() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      final now = DateTime.now();

      // التحقق مما إذا كان الوقت الحالي يطابق وقت الصلاة القادم
      if (nextPrayerTime.value.isNotEmpty) {
        // استبدال الأرقام العربية بالأرقام الإنجليزية
        final arabicNumbers = [
          '٠',
          '١',
          '٢',
          '٣',
          '٤',
          '٥',
          '٦',
          '٧',
          '٨',
          '٩'
        ];
        final englishNumbers = [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9'
        ];
        String convertedNextPrayerTime = nextPrayerTime.value;
        for (int i = 0; i < arabicNumbers.length; i++) {
          convertedNextPrayerTime = convertedNextPrayerTime.replaceAll(
              arabicNumbers[i], englishNumbers[i]);
        }

        // استبدال "ص" و"م" بالتنسيق الإنجليزي
        convertedNextPrayerTime =
            convertedNextPrayerTime.replaceAll("ص", "AM").replaceAll("م", "PM");

        // تحليل الوقت باستخدام الأرقام الإنجليزية
        final nextPrayerDateTime =
            DateFormat("hh:mm a").parse(convertedNextPrayerTime);

        // تحويل الوقت إلى تاريخ كامل (نفس اليوم)
        DateTime nextPrayerFullDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          nextPrayerDateTime.hour,
          nextPrayerDateTime.minute,
        );

        // إذا كان الوقت قد مر، نفترض أنه اليوم التالي
        if (nextPrayerFullDateTime.isBefore(now)) {
          nextPrayerFullDateTime =
              nextPrayerFullDateTime.add(Duration(days: 1));
        }

        // التحقق مما إذا كان الوقت الحالي يطابق وقت الصلاة
        if (now.hour == nextPrayerFullDateTime.hour &&
            now.minute == nextPrayerFullDateTime.minute) {
          // تشغيل الأذان
          await AthanPlayer.playAthan();

          // إرسال إشعار للمستخدم
          await NotificationService.showNotification(nextPrayer.value);

          // إعادة حساب الصلاة القادمة
          getNextPrayerTime();
        }
      }
    });
  }

  /// 🔹 التحقق من الإذن عند تشغيل التطبيق
  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      locationPermissionDenied(true);
      return;
    }

    if (permission == LocationPermission.denied) {
      requestLocationPermission();
    } else {
      checkLocationServiceStatus(); // التحقق من خدمات الموقع هنا
    }
  }

  /// 🔹 طلب إذن الموقع من المستخدم
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      locationPermissionDenied(false);
      checkLocationServiceStatus(); // التحقق من خدمات الموقع بعد منح الإذن
    } else {
      locationPermissionDenied(true);
    }
  }

  Future<void> fetchPrayerTimes() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      locationPermissionDenied(true);
      return;
    }

    isLoading(true);
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // الحصول على طريقة الحساب من الإعدادات
      final settings = Get.find<SettingsController>();
      int method = settings.calculationMethod.value;

      String url =
          "https://api.aladhan.com/v1/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}"
          "?latitude=${position.latitude}"
          "&longitude=${position.longitude}"
          "&method=$method";

      log("API URL: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        log("API Response: $data"); // طباعة البيانات المستلمة من API
        prayerTimes.value = PrayerTimes.fromJson(data['data']['timings']);
        getLocationName(position.latitude, position.longitude);
        getNextPrayerTime();
      } else {
        throw Exception("فشل في جلب أوقات الصلاة");
      }
    } catch (e) {
      location.value = "⚠️ خطأ أثناء تحديد الموقع";
      locationPermissionDenied(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getLocationName(double lat, double lon) async {
    String url =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String city = data['address']['city'] ??
            data['address']['town'] ??
            data['address']['village'] ??
            "غير معروف";
        String country = data['address']['country'] ?? "غير معروف";
        location.value = "$city, $country";
      } else {
        location.value = "الموقع غير متاح";
      }
    } catch (e) {
      location.value = "⚠️ فشل في تحديد الموقع";
    }
  }

  void getNextPrayerTime() {
    if (prayerTimes.value == null) return;

    Map<String, String> prayers = {
      "الفجر": prayerTimes.value!.fajr,
      "الشروق": prayerTimes.value!.sunrise,
      "الظهر": prayerTimes.value!.dhuhr,
      "العصر": prayerTimes.value!.asr,
      "المغرب": prayerTimes.value!.maghrib,
      "العشاء": prayerTimes.value!.isha,
    };

    DateTime now = DateTime.now();
    String? nextPrayerName;
    DateTime? nextPrayerDateTime;

    // طباعة القيم لكل صلاة
    prayers.forEach((prayer, timeStr) {
      DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
      DateTime prayerDateTime = DateTime(
          now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);

      log("Prayer: $prayer, Time: $timeStr, DateTime: $prayerDateTime");
    });

    // تحويل كل وقت إلى DateTime لنفس اليوم
    prayers.forEach((prayer, timeStr) {
      DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
      DateTime prayerDateTime = DateTime(
          now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);

      if (prayerDateTime.isAfter(now)) {
        if (nextPrayerDateTime == null ||
            prayerDateTime.isBefore(nextPrayerDateTime!)) {
          nextPrayerName = prayer;
          nextPrayerDateTime = prayerDateTime;
        }
      }
    });

    if (nextPrayerDateTime == null) {
      DateTime fajrTime = DateFormat("HH:mm").parse(prayerTimes.value!.fajr);
      nextPrayerName = "الفجر";
      nextPrayerDateTime = DateTime(
          now.year, now.month, now.day + 1, fajrTime.hour, fajrTime.minute);
    }

    nextPrayer.value = nextPrayerName ?? "";
    nextPrayerTime.value =
        convertTo12Hour(DateFormat("HH:mm").format(nextPrayerDateTime!));

    log("Next Prayer: ${nextPrayer.value}");
    log("Next Prayer Time: ${nextPrayerTime.value}");
  }

  String convertTo12Hour(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String period = hour >= 12 ? 'مساءاً' : 'صباحاً';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;
    return '$hour:${parts[1]} $period';
  }

  Stream<String> remainingTimeStream() async* {
    while (true) {
      if (nextPrayerTime.value.isEmpty) {
        yield "--:--:--";
        await Future.delayed(Duration(seconds: 1));
        continue;
      }

      final now = DateTime.now();

      // استبدال الأرقام العربية بالأرقام الإنجليزية
      final arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      final englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      String convertedNextPrayerTime = nextPrayerTime.value;
      for (int i = 0; i < arabicNumbers.length; i++) {
        convertedNextPrayerTime = convertedNextPrayerTime.replaceAll(
            arabicNumbers[i], englishNumbers[i]);
      }
      // استبدال "ص" و"م" بالتنسيق الإنجليزي
      convertedNextPrayerTime =
          convertedNextPrayerTime.replaceAll("ص", "AM").replaceAll("م", "PM");

      // log("Converted Next Prayer Time: $convertedNextPrayerTime");

      // تحليل الوقت باستخدام الأرقام الإنجليزية
      final nextPrayerDateTime =
          DateFormat("hh:mm a").parse(convertedNextPrayerTime);

      // تحويل الوقت إلى تاريخ كامل (نفس اليوم)
      DateTime nextPrayerFullDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        nextPrayerDateTime.hour,
        nextPrayerDateTime.minute,
      );

      // log("Next Prayer Full DateTime: $nextPrayerFullDateTime");

      // إذا كان الوقت قد مر، نفترض أنه اليوم التالي
      if (nextPrayerFullDateTime.isBefore(now)) {
        nextPrayerFullDateTime = nextPrayerFullDateTime.add(Duration(days: 1));
      }

      final duration = nextPrayerFullDateTime.difference(now);

      // log("Duration: $duration");

      if (duration.isNegative) {
        yield "00:00:00";

        // تشغيل الأذان عند موعد الصلاة
        await AthanPlayer.playAthan();
        // إرسال إشعار للمستخدم
        await NotificationService.showNotification(nextPrayer.value);

        // إعادة حساب الصلاة القادمة
        getNextPrayerTime();
      } else {
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        yield "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
      }

      await Future.delayed(Duration(seconds: 1));
    }
  }
}
