import 'package:alfurqan/controllers/quran_player_controller.dart';
import 'package:alfurqan/controllers/reader_selection_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/utils/constant.dart';
import 'package:alfurqan/utils/custom_snackbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class QuranPlayerView extends StatelessWidget {
  final QuranPlayerController audioController =
      Get.put(QuranPlayerController());
  final ReaderSelectionController readerController = Get.find();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final surahName = args['surahName'];
    final readerName = args["reader"];
    final surahNumber = args["surahNumber"];
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
      // appBar: AppBar(
      //   title: Text("Player View"),
      // ),
      body: SafeArea(
        child: Center(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300.w,
              height: 350.h,
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.71, -0.71),
                  end: Alignment(-0.71, 0.71),
                  colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Text("القاريء : $readerName ",
                      style: AppFontStyle.alexandria.copyWith(fontSize: 20.sp)),
                  SizedBox(height: 8.h),
                  Text("سورة $surahName ",
                      style: AppFontStyle.alexandria.copyWith(fontSize: 20.sp)),
                  Spacer(),
                  SvgPicture.asset('assets/Quran.svg',
                      width: 200.w, height: 110.h),
                  SizedBox(height: 40.h),
                ],
              ),
            ),

            SizedBox(height: 20.h),
            Obx(() {
              // if (audioController.audioDuration.value <= 0) {
              //   return SizedBox
              //       .shrink(); // إرجاع واجهة فارغة إذا لم يتم تحميل الملف بعد
              // }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDuration(
                        audioController.currentPosition.value.toInt())),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: audioController.audioDuration.value.toDouble(),
                        value: audioController.currentPosition.value.toDouble(),
                        onChanged: (value) {
                          audioController.seekAudio(value.toInt());
                        },
                      ),
                    ),
                    Text(formatDuration(audioController.audioDuration.value)),
                  ],
                ),
              );
            }),

            // audioController.isPlaying.value
            //     ? AyahView(surahNumber: surahNumber)
            //     : Container(),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDownload04,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    showCustomSnackbar(
                        title: 'تنبيه',
                        message: "جاري العمل على تطوير ميزة التحميل");
                  },
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedGoBackward10Sec,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    audioController
                        .seekAudio(audioController.currentPosition.value - 10);
                  },
                ),
                SizedBox(
                  width: 20.w,
                ),
                // ▶️ زر التشغيل/الإيقاف
                Obx(() => CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColor.primaryColor,
                      child: IconButton(
                        icon: HugeIcon(
                          icon: audioController.isPlaying.value
                              ? HugeIcons.strokeRoundedPause
                              : HugeIcons.strokeRoundedPlay,
                          size: 30,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () async {
                          if (!audioController.isPlaying.value) {
                            // إذا لم يكن الصوت مشغلًا، ابدأ التشغيل
                            await audioController.playAudio(surahNumber,
                                readerController.audioBaseUrl.value);
                          } else {
                            // إذا كان الصوت مشغلًا، قم بالإيقاف أو الإيقاف المؤقت
                            await audioController.togglePausePlay();
                          }
                        },
                      ),
                    )),
                SizedBox(
                  width: 20.w,
                ),

                // ⏩ زر التقديم 10 ثوانٍ
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedGoForward10Sec,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    audioController
                        .seekAudio(audioController.currentPosition.value + 10);
                  },
                ),
                Obx(() => IconButton(
                      icon: HugeIcon(
                        icon: audioController.isRepeating.value
                            ? HugeIcons
                                .strokeRoundedRepeatOff // أيقونة إيقاف التكرار
                            : HugeIcons
                                .strokeRoundedRepeat, // أيقونة تشغيل التكرار
                        color: audioController.isRepeating.value
                            ? Colors.red // لون عند التكرار
                            : Get.isDarkMode
                                ? Colors.white
                                : Colors.black, // لون عادي
                        size: 30,
                      ),
                      onPressed: () {
                        audioController.toggleRepeat(); // تبديل التكرار
                      },
                    )),
              ],
            ),
            SizedBox(height: 20),
            // ✅ زر بدء التلاوة
            // ElevatedButton.icon(
            //   icon: Icon(Icons.play_arrow),
            //   label: Text("تشغيل التلاوة"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green[700],
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //   ),
            //   onPressed: () {
            //     audioController.playAudio(
            //         surahNumber, readerController.audioBaseUrl.value);
            //   },
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     audioController.playSurahByReader(
            //         surahNumber, readerController.audioBaseUrl.value);
            //   },
            //   child: Text("▶ تشغيل"),
            // ),
          ],
        )),
      ),
    );
  }
}

// final ReaderSelectionController readerController = Get.find();
// readerController.audioBaseUrl.value
