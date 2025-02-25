import 'dart:developer';
import 'package:alfurqan/models/aya_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/surah_model.dart';
import '../services/api_service.dart';

class SurahController extends GetxController {
  var surahs = <Surah>[].obs;
  var ayahs = <Ayah>[].obs;
  var isLoading = true.obs;
  var isAyahLoading = true.obs;
  // var isPlaying = false.obs;
  // var isPaused = false.obs;
  // var currentAyah = 1.obs;
  final isHeaderVisible = true.obs; // متغير لتحديد ما إذا كان الـ Header مرئيًا
  final Box ayaBox = Hive.box('quranCache');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController scrollController = ScrollController();
  // final AudioController audioController = Get.find();

  var currentSurah = Surah(
    id: 0,
    name: '',
    englishName: '',
    englishNameTranslation: '',
    numberOfAyahs: 0,
    revelationType: '',
  ).obs;
  var isRichTextMode =
      false.obs; // حالة التبديل بين العرض العادي والعرض باستخدام RichText

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchSurahs();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  void refreshAyahs() {
    // تحديث الآيات لإعادة تحميل التفسير
    update(['ayahs']);
  }

  void _scrollListener() {
    if (scrollController.offset > 100 && isHeaderVisible.value) {
      isHeaderVisible.value = false; // إخفاء الـ Header عند التمرير لأسفل
    } else if (scrollController.offset <= 100 && !isHeaderVisible.value) {
      isHeaderVisible.value = true; // إظهار الـ Header عند التمرير لأعلى
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    _audioPlayer.dispose(); // تنظيف الصوت
    super.onClose();
  }

  void fetchSurahs() async {
    try {
      isLoading(true);
      var surahsList = await _apiService.getSurahs();
      surahs.assignAll(surahsList);
    } finally {
      isLoading(false);
    }
  }

  /// ✅ **تحميل الآيات**
  Future fetchAyahs(int surahNumber) async {
    try {
      isAyahLoading(true);

      // التحقق مما إذا كانت السورة مخزنة محليًا
      final cachedData = Hive.box('quranCache').get('surah_$surahNumber');

      if (cachedData != null) {
        log("Loaded ayahs from Hive for Surah $surahNumber");

        // تحويل البيانات المخزنة إلى قائمة من Ayah
        final ayahsList = (cachedData as List)
            .map((json) => Ayah.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        ayahs.assignAll(ayahsList);
      } else {
        log("Fetching ayahs from API for Surah $surahNumber");

        // جلب الآيات من API
        final ayahsList = await _apiService.getAyahs(surahNumber);

        // تخزين البيانات في Hive
        Hive.box('quranCache').put(
          'surah_$surahNumber',
          ayahsList.map((ayah) => ayah.toJson()).toList(),
        );

        ayahs.assignAll(ayahsList);
      }
    } catch (e) {
      log("Error fetching ayahs: $e");
    } finally {
      isAyahLoading(false);
    }
  }

  void setCurrentSurah(Surah surah) {
    currentSurah.value = surah;
  }

  void toggleViewMode() {
    isRichTextMode.value = !isRichTextMode.value;
  }

  /// ✅ **تحميل الصوت من التخزين المحلي إن وجد**
  String? getLocalAudio(int surahId, int ayahNumber) {
    return Hive.box('quranCache').get('audio_${surahId}_$ayahNumber');
  }
}
