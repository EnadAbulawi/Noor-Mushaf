import 'dart:developer';

import 'package:alfurqan/services/tafseer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tafseer_controller.dart';

class SettingsController extends GetxController {
  var fontSize = 22.0.obs;
  var isDarkMode = false.obs;
  // إضافة متغير للتحكم في عرض التفسير
  final RxBool showTafseer = true.obs;

  //==========================================
  final selectedTafseerIdentifier = 'ar.muyassar'.obs;
  final RxMap<String, String> availableTafseers = <String, String>{}.obs;
  final TafseerService _tafseerService = TafseerService();

  //==========================================

  final SharedPreferences prefs;
  SettingsController(this.prefs);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSettings();
      loadSavedTafseer();
      loadAvailableTafseers(); // إضافة تحميل قائمة التفاسير
    });
    // تحميل الإعدادات المحفوظة
    fontSize.value = prefs.getDouble('fontSize') ?? 22.0;
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    // update(); // تحديث القيم فورًا عند تحميلها
  }

  // دالة للتبديل بين إظهار وإخفاء التفسير
  void toggleTafseer() {
    showTafseer.toggle();
    update();
  }

  Future<void> loadAvailableTafseers() async {
    try {
      availableTafseers.value = {
        'ar.muyassar': 'تفسير الميسر',
        'ar.jalalayn': 'تفسير الجلالين',
        'ar.waseet': 'التفسير الوسيط',
        'ar.tabari': 'تفسير الطبري',
        'ar.qurtubi': 'تفسير القرطبي',
        'ar.kathir': 'تفسير ابن كثير',
      };
    } catch (e) {
      log('Error loading tafseers: $e');
      availableTafseers.value = {
        'ar.muyassar': 'تفسير الميسر',
      };
    }
  }

  Future<void> loadSavedTafseer() async {
    selectedTafseerIdentifier.value =
        prefs.getString('selectedTafseer') ?? 'ar.muyassar';
  }

  Future<void> setTafseer(String identifier) async {
    if (availableTafseers.containsKey(identifier)) {
      selectedTafseerIdentifier.value = identifier;
      await prefs.setString('selectedTafseer', identifier);
      Get.snackbar(
        'تم التغيير',
        'تم تغيير التفسير إلى ${availableTafseers[identifier]}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String getCurrentTafseerName() {
    final tafseerController = Get.find<TafseerController>();
    return tafseerController.selectedTafseerName.value;
  }

  void loadSettings() {
    fontSize.value = prefs.getDouble('fontSize') ?? 22.0;
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    update();
  }

  void updateFontSize(double value) {
    fontSize.value = value;
    prefs.setDouble('fontSize', value);
    update();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    prefs.setBool('isDarkMode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    Get.forceAppUpdate();
    // Get.forceAppUpdate();
  }

  void resetSettings() {
    prefs.clear(); // مسح جميع الإعدادات أولاً

    // تعيين القيم الافتراضية
    fontSize.value = 22.0;
    isDarkMode.value = false;
    selectedTafseerIdentifier.value = 'ar.muyassar';

    // حفظ القيم الافتراضية الجديدة
    prefs.setDouble('fontSize', 22.0);
    prefs.setBool('isDarkMode', false);
    prefs.setString('selectedTafseer', 'tafseer_1');

    // تطبيق الوضع الفاتح
    Get.changeThemeMode(ThemeMode.light);

    Get.snackbar(
      'تم إعادة الضبط',
      'تم إعادة ضبط جميع الإعدادات إلى القيم الافتراضية',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
