import 'package:alfurqan/controllers/data_download_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DownloadDataProgress extends StatelessWidget {
  const DownloadDataProgress({
    super.key,
    required this.dataLoadingController,
    required this.settingsController,
  });

  final DataDownloadController dataLoadingController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: Card(
          color: Color(0xff212121),
          // elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Lottie.asset(
                      "assets/download.json",
                      width: 50.w,
                      height: 50.h,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          dataLoadingController.isAudioLoading.value
                              ? "جاري تحميل الصوتيات... ${(dataLoadingController.progress.value * 100).toStringAsFixed(1)}%"
                              : "جاري تحميل بيانات السور والآيات... ${(dataLoadingController.progress.value * 100).toStringAsFixed(1)}%",
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          " ${(dataLoadingController.progress.value * 100).toStringAsFixed(1)} حتى يتم الانتهاء % ",
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            // color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 12.sp),
                // ✅ شريط تقدم حديث داخل كارد
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300], // الخلفية
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: 330.w *
                          (dataLoadingController.isAudioLoading.value
                              ? dataLoadingController.audioProgress.value
                              : dataLoadingController.progress.value),
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.cyan],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // ✅ نسبة التحميل بتصميم عصري
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity:
                          dataLoadingController.progress.value == 1 ? 0.0 : 1.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
