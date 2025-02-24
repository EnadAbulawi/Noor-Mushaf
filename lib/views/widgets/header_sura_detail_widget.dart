import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HeaderSuraInformation extends StatelessWidget {
  const HeaderSuraInformation({
    super.key,
    required this.surahController,
  });

  final SurahController surahController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240.h,
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Positioned.fill(
                // استخدام Positioned.fill لتغطية المساحة بالكامل
                child: ClipRRect(
                  // استخدام ClipRRect للتحكم في الحواف الدائرية
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.71, -0.71),
                        end: Alignment(-0.71, 0.71),
                        colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
                      ),
                    ),
                  ),
                ),
              ),
              // صورة القرآن (مع الشفافية)
              Positioned(
                left: 50.w,
                top: 70.46.h,
                child: Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset(
                    "assets/Quran.svg",
                    height: 185.h, // تحجيم الصورة بشكل مناسب
                  ),
                ),
              ),
              // معلومات السورة (الاسم، الاسم الإنجليزي، نوع النزول، عدد الآيات)
              Positioned(
                left: 0,
                right: 0, // توسيط المعلومات أفقياً
                bottom: 0, // وضع المعلومات في الجزء السفلي
                top: 15.h,
                child: Column(
                  children: [
                    Text(
                      surahController.currentSurah.value.name,
                      textAlign: TextAlign.center,
                      style: AppFontStyle.uthmanicHafs.copyWith(
                        color: Colors.white,
                        fontSize: 40.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      surahController.currentSurah.value.englishName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                    // const SizedBox(height: 16),
                    Divider(
                      color: Colors.white,
                      thickness: 0.4,
                      endIndent: 70.w,
                      indent: 70.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          surahController.currentSurah.value.revelationType ==
                                  "Meccan"
                              ? "مكية"
                              : "مدنية",
                          style: AppFontStyle.balooReg.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const ShapeDecoration(
                            color: Colors.white38,
                            shape: OvalBorder(),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          surahController.currentSurah.value.numberOfAyahs < 10
                              ? '${surahController.currentSurah.value.numberOfAyahs} ايات'
                              : '${surahController.currentSurah.value.numberOfAyahs} ايه',
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.rtl,
                          style: AppFontStyle.balooReg.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 52.h),

                    Visibility(
                      // اظهار الصورة في كل الايات ما عدا سورة الانفال وهي سورة رقم 9
                      visible: surahController.currentSurah.value.id != 9,
                      child: Image.asset('assets/bismillah.png',
                          height: 60.h, width: 220.w),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
