import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'surah_controller.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var isPaused = false.obs;
  var currentAyah = 1.obs;
  var currentSurahNumber = 1.obs;
  var isSurahPlaying = false.obs;
  AudioPlayer? nextPlayer;
  var currentPlayingIndex =
      0.obs; // إضافة متغير لتتبع الآية الحالية في التشغيل المتسلسل

  final surahController = Get.find<SurahController>();

  void qurantogglePausePlay() async {
    if (isPaused.value) {
      await audioPlayer.resume();
      isPaused(false);
    } else {
      await audioPlayer.pause();
      isPaused(true);
    }
  }

  Future<void> playAudio(String url, int ayahNumber, int surahNumber) async {
    try {
      await audioPlayer.stop();

      // تحديث المتغيرات
      currentAyah.value = ayahNumber;
      currentSurahNumber.value = surahNumber;

      // تحديث مؤشر التشغيل الحالي
      var currentSurahAyahs = surahController.ayahs
          .where((ayah) => ayah.surahNumber == surahNumber)
          .toList();
      currentPlayingIndex.value =
          currentSurahAyahs.indexWhere((ayah) => ayah.number == ayahNumber);

      isPlaying(true);
      isPaused(false);

      await audioPlayer.setSourceUrl(url);
      await audioPlayer.resume();

      _preloadNextAyah();
    } catch (e) {
      log("❌ خطأ في تشغيل الصوت: $e");
      isPlaying(false);
      Get.snackbar('خطأ', 'تعذر تشغيل الصوت');
    }
  }

  // دالة لتحميل الآية التالية مسبقاً
  void _preloadNextAyah() async {
    try {
      var currentSurahAyahs = surahController.ayahs
          .where((ayah) => ayah.surahNumber == currentSurahNumber.value)
          .toList();

      int currentIndex = currentSurahAyahs
          .indexWhere((ayah) => ayah.number == currentAyah.value);

      if (currentIndex < currentSurahAyahs.length - 1) {
        var nextAyah = currentSurahAyahs[currentIndex + 1];
        nextPlayer?.dispose();
        nextPlayer = AudioPlayer();
        await nextPlayer?.setSourceUrl(nextAyah.audio!);
      }
    } catch (e) {
      log("❌ خطأ في تحميل الآية التالية مسبقاً: $e");
    }
  }

  Future<void> playNextAyah() async {
    try {
      var currentSurahAyahs = surahController.ayahs
          .where((ayah) => ayah.surahNumber == currentSurahNumber.value)
          .toList();

      int currentIndex = currentSurahAyahs
          .indexWhere((ayah) => ayah.number == currentAyah.value);

      if (currentIndex >= currentSurahAyahs.length - 1) {
        Get.snackbar("تنبيه", "لقد وصلت إلى نهاية السورة");
        return;
      }

      var nextAyah = currentSurahAyahs[currentIndex + 1];
      await playAudio(
          nextAyah.audio!, nextAyah.number, currentSurahNumber.value);
    } catch (e) {
      log("❌ خطأ في تشغيل الآية التالية: $e");
      Get.snackbar('خطأ', 'تعذر تشغيل الآية التالية');
    }
  }

  Future<void> playPreviousAyah() async {
    try {
      var currentSurahAyahs = surahController.ayahs
          .where((ayah) => ayah.surahNumber == currentSurahNumber.value)
          .toList();

      int currentIndex = currentSurahAyahs
          .indexWhere((ayah) => ayah.number == currentAyah.value);

      if (currentIndex <= 0) {
        Get.snackbar("تنبيه", "هذه هي أول آية في السورة");
        return;
      }

      var prevAyah = currentSurahAyahs[currentIndex - 1];
      await playAudio(
          prevAyah.audio!, prevAyah.number, currentSurahNumber.value);
    } catch (e) {
      log("❌ خطأ في تشغيل الآية السابقة: $e");
      Get.snackbar('خطأ', 'تعذر تشغيل الآية السابقة');
    }
  }

  Future<void> playFullSurah() async {
    try {
      if (isSurahPlaying.value) return;

      var currentSurahAyahs = surahController.ayahs
          .where((ayah) => ayah.surahNumber == currentSurahNumber.value)
          .toList();

      isSurahPlaying(true);
      isPlaying(true);
      isPaused(false);

      for (var ayah in currentSurahAyahs) {
        if (!isSurahPlaying.value) break;
        if (ayah.audio != null) {
          await playAudio(ayah.audio!, ayah.number, currentSurahNumber.value);
          await audioPlayer.onPlayerComplete.first;
        }
      }
    } catch (e) {
      log("❌ خطأ في تشغيل السورة: $e");
    } finally {
      isPlaying(false);
      isSurahPlaying(false);
      isPaused(false);
    }
  }

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    nextPlayer?.dispose();
    super.onClose();
  }

  void cleanUp() {
    audioPlayer.stop();
    isPlaying(false);
    isSurahPlaying(false);
    isPaused(false);
  }
}
