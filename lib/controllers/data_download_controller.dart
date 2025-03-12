import 'dart:developer';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/services/api_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataDownloadController extends GetxController {
  final ApiService _apiService = ApiService();
  final Box ayaBox = Hive.box('quranCache');
  final Box audioBox = Hive.box('audioCache');
  var isLoading = false.obs; // لإدارة حالة التحميل
  var progress = 0.0.obs; // تقدم التحميل كنسبة مئوية
  var audioProgress = 0.0.obs; // ✅ نسبة تقدم تحميل الصوتيات
  var isAudioLoading = false.obs; // حالة تحميل الصوتيات
  var isAudioDownloaded = false.obs; // تحقق من تحميل الصوتيات

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1), () {
        checkAndLoadData(); // ✅ تحميل البيانات بعد تأخير قصير لمنع التجميد
        // checkAudioCache(); // التحقق من تحميل الصوتيات
        checkAndLoadAudioData();
      });
    });
    // checkAndLoadData(); // التحقق من البيانات عند بدء التطبيق

    // if (!isAudioDownloaded.value) {
    //   Future.delayed(Duration(seconds: 2), () {
    //     showAudioDownloadDialog(
    //         this); // ✅ تمرير `DataDownloadController` كمعامل
    //   });
    // }
  }

  // void checkAudioCache() {
  //   isAudioDownloaded.value = ayaBox.containsKey('audio_downloaded');
  // }

  void checkAndLoadAudioData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastDownloadedSurah = prefs.getInt('lastDownloadedSurah') ?? 0;

    if (lastDownloadedSurah > 0 && !isAudioLoading.value) {
      Get.snackbar(
        "استئناف التحميل",
        "يتم استئناف تحميل الصوتيات من السورة رقم $lastDownloadedSurah.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

      downloadAllAudioFiles(); // ✅ استئناف التحميل من آخر نقطة توقف
    }
  }

  Future<void> checkAndLoadData() async {
    isLoading(true); // تفعيل حالة التحميل حتى يتم الفحص
    // التحقق من وجود السور والآيات في التخزين المحلي
    bool isDataAvailable = ayaBox.isNotEmpty && ayaBox.containsKey('surah_1');

    if (isDataAvailable) {
      log("✅ البيانات محملة مسبقًا، لن يتم تحميلها مرة أخرى.");
      isLoading(false); // إخفاء حالة التحميل
      checkAudioStatus(); // التحقق من تحميل الصوتيات
      return;
    }

    log("❌ لم يتم العثور على البيانات، جاري تحميلها...");
    try {
      await downloadAllSurahs();
    } catch (e) {
      log("⚠️ فشل تحميل البيانات: $e");
      Get.snackbar("خطأ", "تعذر تحميل البيانات، تحقق من اتصال الإنترنت.");
    } finally {
      isLoading(false);
    }
  }

  // ✅ تحميل بيانات السور والآيات كاملة
  Future<void> downloadAllSurahs() async {
    try {
      isLoading(true);
      progress.value = 0.0;

      final surahsList = await _apiService.getSurahs();
      int totalSurahs = surahsList.length;

      for (int i = 0; i < totalSurahs; i++) {
        final surah = surahsList[i];
        if (ayaBox.containsKey('surah_${surah.id}')) {
          log("✅ سورة ${surah.id} محملة مسبقًا، تخطي التحميل.");
          continue;
        }

        // جلب الآيات لكل سورة
        final ayahsList = await _apiService.getAyahs(surah.id);
        await Future.delayed(
            Duration(milliseconds: 100)); // ✅ تأخير بسيط لمنع تجميد التطبيق

        // تخزين السورة وآياتها في Hive
        ayaBox.put('surah_${surah.id}',
            ayahsList.map((ayah) => ayah.toJson()).toList());

        // تحديث تقدم التحميل
        progress.value = (i + 1) / totalSurahs;
      }

      showCustomSnackbar(
          title: '🎉 نجاح', message: 'تم تحميل جميع السور والآيات بنجاح.');
    } catch (e) {
      log("⚠️ خطأ أثناء تحميل البيانات: $e");
      Get.snackbar('⚠️ خطأ', 'تعذر تحميل البيانات.');
    } finally {
      isLoading(false);
    }
  }

  // ✅ تحميل جميع الملفات الصوتية
  Future<void> downloadAllAudioFiles() async {
    try {
      isAudioLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final surahsList = await _apiService.getSurahs();
      int totalSurahs = surahsList.length;
      int lastDownloadedSurah = prefs.getInt('lastDownloadedSurah') ?? 0;
      int downloadedCount = lastDownloadedSurah;

      for (int i = lastDownloadedSurah; i < totalSurahs; i++) {
        if (!isAudioLoading.value) {
          // ✅ إيقاف التحميل عند الضغط على زر "إيقاف التحميل"
          log("❌ تم إيقاف التحميل عند السورة ${surahsList[i].id}");
          prefs.setInt('lastDownloadedSurah', i);
          return;
        }

        final surah = surahsList[i];
        final ayahsList = await _apiService.getAyahs(surah.id);

        for (var ayah in ayahsList) {
          if (!isAudioLoading.value) {
            return;
          } // ✅ التحقق مرة أخرى داخل الحلقة الداخلية

          if (ayah.audio != null && ayah.audio!.isNotEmpty) {
            await downloadAudioFile(ayah.audio!, surah.id, ayah.number);
          }
        }

        downloadedCount++;
        audioProgress.value = downloadedCount / totalSurahs;
        prefs.setInt('lastDownloadedSurah', i + 1);
      }

      isAudioDownloaded.value = true;
      prefs.remove('lastDownloadedSurah');
      showCustomSnackbar(
        title: '🎉 نجاح',
        message: 'تم تحميل جميع الملفات الصوتية.',
        backgroundColor: Colors.green,
        margin: EdgeInsets.all(16.0),
      );
    } catch (e) {
      log("⚠️ خطأ أثناء تحميل الصوتيات: $e");
    } finally {
      isAudioLoading(false);
    }
  }

  // ✅ تحميل ملف صوتي واحد
  Future<void> downloadAudioFile(
      String url, int surahNumber, int ayahNumber) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final key = 'audio_${surahNumber}_$ayahNumber';
        await audioBox.put(key, response.bodyBytes);
        log("Audio downloaded for Surah $surahNumber Ayah $ayahNumber");
      }
    } catch (e) {
      log("⚠️ خطأ أثناء تحميل الملف الصوتي: $e");
    }
  }

  // ✅ إظهار تنبيه للمستخدم عند بدء التطبيق

  void showAudioDownloadDialog(
      DataDownloadController dataLoadingController) async {
    final prefs = await SharedPreferences.getInstance();
    bool neverAskAgain = prefs.getBool('neverAskAudioDownload') ?? false;

    if (neverAskAgain)
      return; // ✅ لا تظهر النافذة مرة أخرى إذا اختار المستخدم "عدم الإزعاج"

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Lottie.asset(
                  "assets/download.json",
                  width: 50.w,
                  height: 50.h,
                ),
                Spacer(),
                Text(
                  "تحميل الملفات \n الصوتية",
                  textAlign: TextAlign.end,
                  style: AppFontStyle.alexandria
                      .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Divider(),

            SizedBox(height: 12.h),
            Text(
              "يمكنك تحميل جميع الملفات الصوتية الآن لتجنب الحاجة إلى الإنترنت أثناء التشغيل ولتشغيل القراءة بسرعة",
              textAlign: TextAlign.end,
              // textDirection: TextDirection.rtl,
              style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),

            // ✅ أزرار التحميل والتخطي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("لاحقًا",
                      style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp)),
                  onPressed: () => Get.back(),
                ),
                SizedBox(width: 16.w),
                ElevatedButton.icon(
                  icon: Icon(Icons.download),
                  label: Text(
                    "تحميل الآن",
                    style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
                  ),
                  onPressed: () {
                    Get.back(); // ✅ إغلاق النافذة الأولى

                    // ✅ إظهار نافذة تقدم التحميل
                    Get.bottomSheet(
                      Obx(() => Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.grey[900]
                                  : Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                //add lotti eanimation
                                SizedBox(
                                  height: 100.h,
                                  width: 100.w,
                                  child: Lottie.asset(
                                    "assets/download.json",
                                    // width: 100.w,
                                    // height: 100.h,
                                  ),
                                ),
                                // Icon(Icons.download,
                                //     size: 50, color: Get.theme.primaryColor),
                                SizedBox(height: 12.h),
                                Text(
                                  "جاري تحميل الصوتيات...",
                                  style: AppFontStyle.alexandria.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16.sp),

                                // ✅ شريط تقدم التحميل
                                LinearProgressIndicator(
                                  value:
                                      dataLoadingController.audioProgress.value,
                                  minHeight: 8,
                                ),
                                SizedBox(height: 8.h),
                                SizedBox(height: 8),

                                // ✅ زر إغلاق النافذة مع استمرار التحميل
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.snackbar(
                                      "تنبيه",
                                      "سيستمر تحميل الملفات الصوتية في الخلفية يمكنك التوجه الى الاعدادات لرؤية نسبة اكمال التحميل",
                                      snackPosition: SnackPosition.BOTTOM,
                                      padding: EdgeInsets.all(16),
                                    );
                                  },
                                  child: Text("إخفاء واستكمال التحميل",
                                      style: AppFontStyle.alexandria
                                          .copyWith(fontSize: 16.sp)),
                                ),

                                Text(
                                  "تم تحميل ${(dataLoadingController.audioProgress.value * 100).toStringAsFixed(1)}% من الصوتيات",
                                  style: AppFontStyle.alexandria
                                      .copyWith(fontSize: 16.sp),
                                ),
                                SizedBox(height: 12.h),

                                // ✅ زر إيقاف التحميل
                                ElevatedButton.icon(
                                  icon: Icon(Icons.cancel),
                                  label: Text("إيقاف التحميل",
                                      style: AppFontStyle.alexandria
                                          .copyWith(fontSize: 16.sp)),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt(
                                        'lastDownloadedSurah',
                                        (dataLoadingController
                                                    .audioProgress.value *
                                                100)
                                            .toInt());

                                    dataLoadingController.isAudioLoading.value =
                                        false; // ✅ تحديث الحالة بشكل صحيح
                                    log("❌ تم إيقاف تحميل الصوتيات عند ${(dataLoadingController.audioProgress.value * 100).toStringAsFixed(1)}%");

                                    // ✅ تأخير بسيط لضمان إغلاق `BottomSheet`
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      Get.back(); // ✅ إغلاق `BottomSheet`
                                      Get.snackbar(
                                        "تنبيه",
                                        "تم إيقاف التحميل عند ${(dataLoadingController.audioProgress.value * 100).toStringAsFixed(1)}%. يمكنك استئنافه من الإعدادات.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        padding: EdgeInsets.all(16),
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        duration: Duration(seconds: 3),
                                        margin: EdgeInsets.all(16),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          )),
                      isDismissible: false,
                    );

                    // ✅ بدء تحميل الصوتيات بعد عرض النافذة
                    dataLoadingController.downloadAllAudioFiles();
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: neverAskAgain,
                  onChanged: (value) {
                    prefs.setBool('neverAskAudioDownload', value!);
                    Get.back();
                  },
                ),
                Spacer(),
                Text("عدم الإزعاج مرة أخرى",
                    style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp)),
              ],
            ),
          ],
        ),
      ),
      isDismissible: false,
    );
  }

  // التحقق إذا كانت سورة معينة مخزنة
  bool isSurahCahced(int surahNumber) {
    return ayaBox.containsKey('surah_$surahNumber');
  }

  // تحميل سورة محددة
  Future<List<Ayah>> downloadSurah(int surahNumber) async {
    if (isSurahCahced(surahNumber)) {
      log("Loaded Surah $surahNumber from Hive.");
      final cachedsurah = ayaBox.get('surah_$surahNumber');
      return List<Ayah>.from(cachedsurah.map((surah) => Ayah.fromJson(surah)));
    } else {
      log("Fetching Surah $surahNumber from API.");
      final ayahsList = await _apiService.getAyahs(surahNumber);
      ayaBox.put('surah_$surahNumber',
          ayahsList.map((ayah) => ayah.toJson()).toList());

      log("Cached Surah $surahNumber in Hive.");
      return ayahsList;
    }
  }

  Future<void> checkAudioStatus() async {
    // ✅ التحقق مما إذا كانت الملفات الصوتية محملة مسبقًا
    if (audioBox.isEmpty) {
      showAudioDownloadDialog(this); // ✅ تمرير `DataDownloadController` كمعامل
    }
  }
}
