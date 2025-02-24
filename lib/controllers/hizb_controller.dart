import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/hizb_model.dart';
import 'package:alfurqan/services/api_service.dart';
import 'package:get/get.dart';
import '../models/surah_model.dart';
import '../views/Hizb View/hizb_detail_view.dart';

class HizbController extends GetxController {
  final ApiService _apiService = ApiService();
  final SurahController _surahController = Get.find();
  final RxBool isLoading = false.obs;
  final RxList<HizbQuarter> hizbQuarters = <HizbQuarter>[].obs;
  final Rx<HizbQuarter?> currentHizbQuarter = Rx<HizbQuarter?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAllHizbQuarters();
  }

  String getSurahName(int surahNumber) {
    final surah = _surahController.surahs.firstWhere(
      (s) => s.name == surahNumber,
      orElse: () => Surah(
          id: 0,
          name: '',
          englishName: '',
          englishNameTranslation: '',
          numberOfAyahs: 0,
          revelationType: ''),
    );
    return surah.name;
  }

  Future<void> loadAllHizbQuarters() async {
    try {
      isLoading.value = true;
      final result = await _apiService.getAllHizbQuarters();
      hizbQuarters.value = result;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHizbQuarter(int quarterNumber) async {
    try {
      isLoading.value = true;
      currentHizbQuarter.value =
          await _apiService.getHizbQuarter(quarterNumber);
      Get.to(() => HizbDetailView());
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
