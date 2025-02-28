import 'dart:developer';

import 'package:alfurqan/controllers/bookmark_controller.dart';
import 'package:alfurqan/controllers/last_read_controller.dart';
import 'package:alfurqan/controllers/quran_player_controller.dart';
import 'package:alfurqan/controllers/reader_selection_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/views/Hizb%20View/hizb_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/audio_Controller.dart';
import 'controllers/data_download_controller.dart';
import 'controllers/hizb_controller.dart';
import 'controllers/juz_controller.dart';
import 'controllers/surah_controller.dart';
import 'controllers/tafseer_controller.dart';
import 'models/aya_model.dart';
import 'services/life_cycle.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(AyahAdapter());

    await Future.wait([
      Hive.openBox('quranCache'),
      Hive.openBox('audioCache'),
      Hive.openBox('settings'),
    ]);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Initialize controllers
    Get.put(SettingsController(prefs), permanent: true);
    Get.put(BookmarkController(), permanent: true);
    Get.put(DataDownloadController(), permanent: true);
    Get.put(SurahController(), permanent: true);
    Get.put(AudioController(), permanent: true);
    Get.put(TafseerController(), permanent: true);
    Get.put(LastReadController(prefs: prefs), permanent: true);
    Get.put(JuzController());
    Get.put(HizbController());
    Get.put(ReaderSelectionController());
    Get.put(QuranPlayerController());

    // ... other controllers ...

    // Add lifecycle observer
    final lifecycleHandler = LifecycleEventHandler(
      detachedCallBack: () async {
        // Clean up resources when app is closed
        await Hive.close();
        Get.find<AudioController>().cleanUp();
      },
      resumeCallBack: () async {
        // Optional: handle app resume
        await Get.find<BookmarkController>().loadBookmarks();
      },
    );

    WidgetsBinding.instance.addObserver(lifecycleHandler);

    runApp(MyApp());
  } catch (e) {
    log('Error initializing app: $e');
  }
  // إغلاق صناديق Hive عند إغلاق التطبيق
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      detachedCallBack: () async {
        await Hive.close();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        Get.put(SurahController());
        return GetMaterialApp(
          // initialBinding: AppBindings(), // ✅ استدعاء الـ Bindings هنا
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: Get.find<SettingsController>().isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home: HomeView(),
          getPages: [
            GetPage(
              name: '/hizb-detail',
              page: () => HizbDetailView(),
              transition: Transition.rightToLeft,
            ),
          ],
        );
      },
    );
  }
}
