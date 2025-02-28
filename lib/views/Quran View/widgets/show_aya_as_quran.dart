import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
                style: AppFontStyle.uthmanicHafs.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RichText(
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              strutStyle: StrutStyle(
                // height: 3.0.h,
                // forceStrutHeight: false,
                leading: 2.9.w,
              ),
              text: TextSpan(
                style: AppFontStyle.uthmanTN1.copyWith(
                  fontSize: 24.sp,
                  // letterSpacing: 0.9.w,
                  // wordSpacing: 1.w,
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
                children: surahController.ayahs.map((ayah) {
                  return TextSpan(
                    children: [
                      WidgetSpan(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: SvgPicture.asset(
                                'assets/numberbracket.svg',
                                color: const Color(0xff4477CE),
                                width: 35,
                                height: 35,
                              ),
                            ),
                            Text(
                              '${ayah.number}',
                              style: AppFontStyle.uthmanicHafs.copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: ayah.text,
                        style: AppFontStyle.kitab.copyWith(
                          fontSize: settingsController.fontSize.value,
                          // // height: 0.3.h,
                          letterSpacing: 0.5.w,
                          wordSpacing: 0.5.w,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
