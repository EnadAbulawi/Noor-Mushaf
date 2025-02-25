import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastReadController extends GetxController {
  var lastReadSurah = "".obs;
  var lastReadSurahId = 0.obs;
  var lastReadAyah = 0.obs;

  final SharedPreferences prefs;
  LastReadController({required this.prefs});
  @override
  void onInit() {
    super.onInit();
    loadLastRead();
  }

  void loadLastRead() {
    lastReadSurah.value = prefs.getString('lastReadSurah') ?? '';
    lastReadSurahId.value = prefs.getInt('lastReadSurahId') ?? 0;
    lastReadAyah.value = prefs.getInt('lastReadAyah') ?? 0;
  }

  void updateLastRead(String surahName, int ayahNumber, int surahId) {
    lastReadSurah.value = surahName;
    lastReadAyah.value = ayahNumber;
    lastReadSurahId.value = surahId;
    // حفظ البيانات
    prefs.setString('lastReadSurah', surahName);
    prefs.setInt('lastReadSurahId', surahId);
    prefs.setInt('lastReadAyah', ayahNumber);
  }

  void clearLastRead() {
    lastReadSurah.value = '';
    lastReadAyah.value = 0;
    lastReadSurahId.value = 0;
    prefs.remove('lastReadSurah');
    prefs.remove('lastReadAyah');
    prefs.remove('lastReadSurahId');
  }
}
