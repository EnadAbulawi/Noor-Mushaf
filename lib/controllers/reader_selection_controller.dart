import 'dart:developer';

import 'package:alfurqan/services/quran_player_api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderSelectionController extends GetxController {
  final QuranPlayerApi _apiService = QuranPlayerApi();

  // تغيير طريقة تعريف القوائم
  final _readers = <Map<String, dynamic>>[].obs;
  final _filteredReaders = <Map<String, dynamic>>[].obs;

  // إضافة getters للقوائم
  List<Map<String, dynamic>> get readers => _readers.toList();
  List<Map<String, dynamic>> get filteredReaders => _filteredReaders.toList();

  var surahs = <Map<String, dynamic>>[].obs; // قائمة السور
  var selectedReader = "".obs; // القارئ المختار
  var audioBaseUrl = "".obs; // رابط السيرفر الخاص بالقارئ
  var selectedReaderName = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadReaders();
    loadSurahs();
    loadSelectedReader();
  }

  Future<void> loadReaders() async {
    try {
      final fetchedReaders = await _apiService.getReciters();
      if (fetchedReaders.isNotEmpty) {
        _readers.clear();
        _readers.addAll(fetchedReaders);
        _filteredReaders.clear();
        _filteredReaders.addAll(fetchedReaders);
      }
    } catch (e) {
      log('Error loading readers: $e');
    }
  }

  void searchReader(String query) {
    if (_readers.isEmpty) return;

    try {
      _filteredReaders.clear();

      if (query.trim().isEmpty) {
        _filteredReaders.addAll(_readers);
        return;
      }

      final searchQuery = query.trim().toLowerCase();
      final results = _readers.where((reader) {
        return reader['name'].toString().toLowerCase().contains(searchQuery);
      }).toList();

      _filteredReaders.addAll(results);
    } catch (e) {
      log('Search error: $e');
      _filteredReaders.clear();
      _filteredReaders.addAll(_readers);
    }
  }

  /// تحميل قائمة السور من API
  Future<void> loadSurahs() async {
    surahs.value = await _apiService.getSurahs();
  }

  /// تحميل القارئ المختار من `SharedPreferences`
  Future<void> loadSelectedReader() async {
    final prefs = await SharedPreferences.getInstance();
    selectedReader.value = prefs.getString("selectedReader") ?? "";
    selectedReaderName.value = prefs.getString("selectedReaderName") ?? "";
    audioBaseUrl.value = prefs.getString("audioBaseUrl") ?? "";
    update();
  }

  /// عند اختيار القارئ، نقوم بتخزينه في `SharedPreferences`
  Future<void> selectReader(String readerId) async {
    final reciter = readers.firstWhere(
      (r) => r['id'].toString() == readerId,
      orElse: () => {}, // إذا لم يتم العثور على القارئ، استخدم كائن فارغ
    );

    if (reciter.isEmpty) {
      Get.snackbar("⚠️ خطأ", "القارئ غير موجود، يرجى اختيار قارئ آخر.");
      return;
    }

    selectedReader.value = readerId;
    selectedReaderName.value = reciter['name'];

    audioBaseUrl.value = reciter['moshaf'][0]['server'];

    if (audioBaseUrl.value.isEmpty) {
      Get.snackbar("⚠️ خطأ", "لم يتم العثور على رابط التلاوات لهذا القارئ.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedReader", readerId);
    prefs.setString("selectedReaderName", selectedReaderName.value);
    prefs.setString("audioBaseUrl", audioBaseUrl.value);
    update();
  }
}
