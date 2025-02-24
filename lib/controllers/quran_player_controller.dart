import 'dart:async';
import 'dart:developer';
import 'package:alfurqan/utils/custom_snackbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class QuranPlayerController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var isPaused = false.obs;
  var currentPosition = 0.obs;
  var audioDuration = 0.obs;
  var isLoading = false.obs; // ✅ لمعرفة حالة التحميل
  var isRepeating = false.obs; // ✅ لمعرفة حالة التكرار

  @override
  void onInit() {
    super.onInit();
    audioPlayer.onDurationChanged.listen((duration) {
      audioDuration.value = duration.inSeconds;
    });

    audioPlayer.onPositionChanged.listen((position) {
      currentPosition.value = position.inSeconds;
    });

    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying(false);
    });
  }

  Future<void> playAudio(int surahNumber, String baseUrl) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar("⚠️ خطأ", "لا يوجد اتصال بالإنترنت");
      return;
    }

    try {
      if (baseUrl.isEmpty) {
        Get.snackbar("⚠️ خطأ", "لم يتم العثور على رابط التلاوة للقارئ المختار");
        return;
      }

      String surahNumberStr = surahNumber.toString().padLeft(3, '0');
      String url = '$baseUrl$surahNumberStr.mp3';

      log("🔊 تشغيل الصوت من: $url");

      await audioPlayer
          .setSource(UrlSource(url)); // ✅ استخدام UrlSource بدل setSourceUrl
      await audioPlayer.resume();
      isPlaying(true);
      isPaused(false);
    } catch (e) {
      log("❌ خطأ أثناء تشغيل الصوت: $e");
      Get.snackbar("⚠️ خطأ", "تعذر تشغيل السورة، تحقق من الرابط.");
    }
  }

  Future<void> togglePausePlay() async {
    if (isPaused.value) {
      await audioPlayer.resume();
      isPaused(false);
      isPlaying(true);
    } else {
      await audioPlayer.pause();
      isPaused(true);
      isPlaying(false);
    }
  }

  Future<void> seekAudio(int seconds) async {
    await audioPlayer.seek(Duration(seconds: seconds));
  }

  //repeatAudio
  Future<void> repeatAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    showCustomSnackbar(
      title: "تنبيه",
      message: "تم تشغيل التكرار",
      backgroundGradient: LinearGradient(
        colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
        begin: Alignment(-0.71, 0.71),
        end: Alignment(0.71, -0.71),
      ),
    );
  }

  //stoprepeatAudio
  Future<void> stopRepeatAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.stop);
    showCustomSnackbar(
      title: "تنبيه",
      message: "تم ايقاف التكرار",
      backgroundGradient: LinearGradient(
        colors: [Colors.red, Colors.redAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  void toggleRepeat() {
    isRepeating.value = !isRepeating.value;
    if (isRepeating.value) {
      repeatAudio();
    } else {
      stopRepeatAudio();
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // ✅ تنظيف الموارد عند مغادرة الصفحة
    super.onClose();
  }
}
