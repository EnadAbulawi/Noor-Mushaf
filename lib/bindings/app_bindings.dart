// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../controllers/AudioController.dart';
// import '../controllers/settings_controller.dart';
// import '../controllers/bookmark_controller.dart';
// import '../controllers/reader_selection_controller.dart';
// import '../controllers/data_download_controller.dart';
// import '../controllers/surah_controller.dart';

// class AppBindings extends Bindings {
//   @override
//   Future<void> dependencies() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // تسجيل الـ Controllers هنا
//     Get.lazyPut(() => SettingsController(prefs));
//     Get.put(BookMarkController(prefs));
//     Get.put(ReaderSelectionController());
//     Get.put(DataDownloadController());
//     Get.put(SurahController());
//   }
// }
