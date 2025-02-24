import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/tafseer_service.dart';
import 'surah_controller.dart';

class TafseerController extends GetxController {
  final TafseerService _tafseerService = TafseerService();
  final RxString selectedTafseerId = '1'.obs;
  final RxString selectedTafseerName = 'تفسير الميسر'.obs;
  final RxList<Map<String, dynamic>> availableTafseers =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSelectedTafseer();
    fetchAvailableTafseers();
  }

  Future<void> fetchAvailableTafseers() async {
    availableTafseers.assignAll([
      {'id': '1', 'name': 'تفسير الميسر'},
      {'id': '2', 'name': 'تفسير الجلالين'},
      {'id': '3', 'name': 'تفسير السعدي'},
      {'id': '4', 'name': 'تفسير ابن كثير'},
      {'id': '5', 'name': "تفسير الوسيط لطنطاوي"},
      {'id': '6', 'name': "تفسير البغوي"},
    ]);
  }

  Future<void> setSelectedTafseer(String id) async {
    final tafseer = availableTafseers.firstWhere(
      (t) => t['id'].toString() == id,
      orElse: () => {'id': '1', 'name': 'تفسير الميسر'},
    );

    selectedTafseerId.value = id;
    selectedTafseerName.value = tafseer['name'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTafseerId', id);
    await prefs.setString('selectedTafseerName', tafseer['name']);

    // تحديث التفسير في جميع الآيات المعروضة
    if (Get.isRegistered<SurahController>()) {
      Get.find<SurahController>().refreshAyahs();
    }
  }

  Future<void> loadSelectedTafseer() async {
    final prefs = await SharedPreferences.getInstance();
    selectedTafseerId.value = prefs.getString('selectedTafseerId') ?? '1';
    selectedTafseerName.value =
        prefs.getString('selectedTafseerName') ?? 'تفسير الميسر';
  }

  Future<String> getAyahTafseer(int surahNumber, int ayahNumber) async {
    try {
      return await _tafseerService.getTafseerById(
        selectedTafseerId.value,
        surahNumber,
        ayahNumber,
      );
    } catch (e) {
      return 'حدث خطأ في جلب التفسير';
    }
  }
}
