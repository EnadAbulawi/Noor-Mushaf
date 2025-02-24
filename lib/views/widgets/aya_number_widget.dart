import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AyaNumberWidget extends StatelessWidget {
  const AyaNumberWidget({
    super.key,
    required this.ayah,
  });

  final Ayah ayah;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 27,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/numberbracket.svg',
                  width: 27,
                  height: 27,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
          ),
          Positioned(
            left: ayah.number < 10 ? 10 : 7,
            top: ayah.number > 99 ? 7 : 6,
            child: Text(
              '${ayah.number}',
              textAlign: TextAlign.center,
              style: AppFontStyle.balooBold.copyWith(
                fontSize: ayah.number > 99 ? 11 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
