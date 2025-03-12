import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ShowAyaAsQuran extends StatelessWidget {
  const ShowAyaAsQuran({
    super.key,
    required this.surahController,
    required this.settingsController,
  });

  final SurahController surahController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // إطار اسم السورة
          Container(
            height: 40.h,
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/surahBorder.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Text(
                surahController.currentSurah.value.name,
                style: AppFontStyle.kitab,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              child: Obx(
                () => RichText(
                  key: ValueKey(surahController.ayahs.length),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,

                  // strutStyle: StrutStyle(
                  //   // height: 3.0.h,
                  //   // forceStrutHeight: false,
                  //   leading: 2.9.w,
                  // ),
                  text: TextSpan(
                    style: AppFontStyle.kitab.copyWith(
                      fontSize: 24.sp,
                      color: settingsController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    ),
                    children: surahController.ayahs.map((ayah) {
                      return TextSpan(
                        children: [
                          TextSpan(
                            text: ayah.text,
                            style: AppFontStyle.kitab.copyWith(
                                fontSize: settingsController.fontSize.value,
                                letterSpacing: 0.4.w,
                                wordSpacing: 0.5.w,
                                height: 1.5.h),
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/numberbracket.svg',
                                    color: const Color(0xff4477CE),
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                  Text(
                                    '${ayah.number}',
                                    style: AppFontStyle.uthmanicHafs.copyWith(
                                      fontSize: 15.sp,
                                      // color: Colors.white, // لون الرقم
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // TextSpan(
                          //   text: ayah.text,
                          //   style: AppFontStyle.kitab.copyWith(
                          //     fontSize: settingsController.fontSize.value,
                          //     // // height: 0.3.h,
                          //     letterSpacing: 0.5.w,
                          //     wordSpacing: 0.5.w,
                          //   ),
                          // ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
