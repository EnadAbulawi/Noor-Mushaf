import 'package:alfurqan/services/api_service.dart';
import 'package:get/get.dart';
import '../models/juz_model.dart';

class JuzController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<JuzModel> juzList = <JuzModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final currentJuz = Rxn<JuzModel>();

  Future<void> loadJuz(int juzNumber) async {
    try {
      isLoading(true);
      error('');
      final juzData = await _apiService.getJuz(juzNumber);
      currentJuz(juzData);
    } catch (e) {
      error('حدث خطأ أثناء تحميل البيانات');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadAllJuz() async {
    try {
      isLoading.value = true;
      error.value = '';
      for (int i = 1; i <= 30; i++) {
        final juz = await _apiService.getJuz(i);
        juzList.add(juz);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
