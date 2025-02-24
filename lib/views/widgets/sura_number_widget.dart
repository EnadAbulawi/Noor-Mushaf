import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SuraNumberWidget extends StatelessWidget {
  const SuraNumberWidget({
    super.key,
    required this.surah,
  });

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      height: 45.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 45.w,
              height: 45.w,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/numberbracket.svg',
                    width: 45.w,
                    height: 45.w,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: surah.id < 10.w ? 19.w : 13.w,
            top: surah.id > 99.h ? 13.h : 13.h,
            child: Text(
              '${surah.id}',
              textAlign: TextAlign.center,
              style: AppFontStyle.poppins.copyWith(
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
