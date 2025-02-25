import 'package:alfurqan/controllers/last_read_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Quran View/sura_detail_view.dart';

class LastReadWidget extends StatelessWidget {
  final SettingsController settingsController;
  final SurahController surahController;

  const LastReadWidget(
      {super.key,
      required this.settingsController,
      required this.surahController});

  @override
  Widget build(BuildContext context) {
    final LastReadController lastReadController = Get.find();
    return Obx(
      () => Column(
        children: [
          GestureDetector(
            onTap: () {
              if (lastReadController.lastReadSurahId.value > 0) {
                surahController.setCurrentSurah(
                  surahController.surahs.firstWhere(
                    (surah) =>
                        surah.id == lastReadController.lastReadSurahId.value,
                  ),
                );
                surahController
                    .fetchAyahs(lastReadController.lastReadSurahId.value);
                Get.to(() => SurahDetailView(
                      initialAyahNumber: lastReadController.lastReadAyah.value,
                    ));
              }
              // surahController.setCurrentSurah(surahController.currentSurah.value);
              // surahController.fetchAyahs(surahController.currentSurah.value.id);
              // Get.to(() => SurahDetailView());
            },
            child: Container(
              width: 326.w,
              height: 131.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 326.w,
                    height: 131.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 326.w,
                            height: 131.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 326.w,
                                    height: 131.h,
                                    decoration: ShapeDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment(0.71, -0.71),
                                        end: Alignment(-0.71, 0.71),
                                        colors: [
                                          Color(0xFFDF98FA),
                                          Color(0xFF9055FF)
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 160.w,
                                  top: 35.h,
                                  child: Container(
                                      width: 190.w,
                                      height: 126.h,
                                      child:
                                          SvgPicture.asset('assets/Quran.svg')),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 19,
                          child: Container(
                            width: 107.w,
                            height: 93.h,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 41,
                                  child: SizedBox(
                                    width: 100.w,
                                    child: Text(
                                      lastReadController.lastReadSurah.value,
                                      style: AppFontStyle.uthmanicHafs.copyWith(
                                        color: Colors.white,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 85,
                                  child: SizedBox(
                                    width: 89.w,
                                    child: Opacity(
                                      opacity: 0.80,
                                      child: Text(
                                        'آية رقم: ${lastReadController.lastReadAyah.value}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 107.w,
                                    height: 21.h,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 20.w,
                                          height: 20.h,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.73),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/book.svg')
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 79.w,
                                          child: Text(
                                            'اخر قراءة',
                                            style:
                                                AppFontStyle.balooReg.copyWith(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
