import 'dart:developer';
import 'dart:io';
import 'package:alfurqan/models/aya_model.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'surah_controller.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var isPaused = false.obs;
  var currentAyah = 1.obs;
  var currentSurahNumber = 1.obs;
  var audioCache = Hive.box('audioCache');
  var isSurahPlaying = false.obs;
  var isLoading = false.obs;
  final Set<int> _loadedSurahs = {};

  final surahController = Get.find<SurahController>();

  // تحميل صوتيات السورة
  Future<void> loadSurahAudio(int surahNumber) async {
    if (_loadedSurahs.contains(surahNumber)) return;

    isLoading.value = true;
    try {
      for (var ayah in surahController.ayahs) {
        if (ayah.audio != null) {
          String? localAudio = await getLocalAudio(surahNumber, ayah.number);
          if (localAudio == null) {
            await saveAudioLocaly(ayah.audio!, surahNumber, ayah.number);
          }
        }
      }
      _loadedSurahs.add(surahNumber);
    } catch (e) {
      log("❌ خطأ في تحميل الصوتيات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // التحقق من وجود الصوتيات
  bool isSurahLoaded(int surahNumber) {
    return _loadedSurahs.contains(surahNumber);
  }

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
      if (!isSurahLoaded(surahNumber)) {
        await loadSurahAudio(surahNumber);
      }

      currentAyah.value = ayahNumber;
      currentSurahNumber.value = surahNumber;
      isPlaying(true);
      isPaused(false);

      String? localAudio = await getLocalAudio(surahNumber, ayahNumber);
      if (localAudio != null) {
        await audioPlayer.play(DeviceFileSource(localAudio));
      } else {
        await audioPlayer.play(UrlSource(url));
        saveAudioLocaly(url, surahNumber, ayahNumber);
      }

      audioPlayer.onPlayerComplete.listen((_) {
        isPlaying(false);
      });
    } catch (e) {
      isPlaying(false);
      Get.snackbar('خطأ', 'تعذر تشغيل الصوت');
    }
  }

  Future<void> playNextAyah() async {
    if (currentAyah.value >= surahController.ayahs.length) {
      Get.snackbar("تنبيه", "لقد وصلت إلى نهاية السورة");
      return;
    }

    int nextAyahNumber = currentAyah.value + 1;
    Ayah nextAyah = surahController.ayahs[nextAyahNumber - 1];

    await playAudio(nextAyah.audio!, nextAyahNumber, currentSurahNumber.value);
  }

  Future<void> playPreviousAyah() async {
    if (currentAyah.value > 1) {
      int prevAyahNumber = currentAyah.value - 1;
      Ayah prevAyah = surahController.ayahs[prevAyahNumber - 1];

      await playAudio(
          prevAyah.audio!, prevAyahNumber, currentSurahNumber.value);
    } else {
      Get.snackbar("تنبيه", "هذه هي أول آية في السورة");
    }
  }

  Future<void> playFullSurah() async {
    if (isSurahPlaying.value) return;

    if (!isSurahLoaded(currentSurahNumber.value)) {
      await loadSurahAudio(currentSurahNumber.value);
    }

    isSurahPlaying(true);
    isPlaying(true);
    isPaused(false);

    for (var ayah in surahController.ayahs) {
      if (!isSurahPlaying.value) break;

      currentAyah.value = ayah.number;
      String? localAudio =
          await getLocalAudio(currentSurahNumber.value, ayah.number);
      String audioSource = localAudio ?? ayah.audio!;

      await audioPlayer.play(localAudio != null
          ? DeviceFileSource(localAudio)
          : UrlSource(audioSource));
      await audioPlayer.onPlayerComplete.first;
    }

    isPlaying(false);
    isSurahPlaying(false);
  }

  Future<void> saveAudioLocaly(
      String url, int surahNumber, int ayahNumber) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/audio_$surahNumber$ayahNumber.mp3';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        await audioCache.put('audio_$surahNumber$ayahNumber', filePath);
      }
    } catch (e) {
      log("❌ خطأ في حفظ الصوت: $e");
    }
  }

  Future<String?> getLocalAudio(int surahNumber, int ayahNumber) async {
    return audioCache.get('audio_$surahNumber$ayahNumber');
  }

  // تنظيف الذاكرة من الصوتيات غير المستخدمة
  void clearUnusedAudio() {
    _loadedSurahs.clear();
  }

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.onClose();
  }

  void cleanUp() {
    audioPlayer.stop();
    currentSurahNumber.value = 0;
    isPlaying.value = false;
    clearUnusedAudio();
  }
}
