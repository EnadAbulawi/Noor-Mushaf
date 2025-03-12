import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowcaseService extends GetxService {
  // متغير لتتبع حالة العرض التوضيحي
  var isShowCaseShown = false.obs;

  // دالة للتحقق مما إذا كان العرض التوضيحي قد تم عرضه مسبقًا
  Future<bool> isShowcaseShown(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  // دالة لحفظ حالة العرض التوضيحي
  Future<void> setShowcaseShown(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
    isShowCaseShown.value = true;
  }
}
