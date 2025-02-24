import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';

class SuraInformationWidget extends StatelessWidget {
  const SuraInformationWidget({
    super.key,
    required this.surah,
  });

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            surah.englishName,
            style: AppFontStyle.balooReg.copyWith(
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(surah.revelationType == "Meccan" ? "مكية" : "مدنية",
                  textAlign: TextAlign.start,
                  style: AppFontStyle.balooReg.copyWith(
                    fontSize: 14,
                  )),
              Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryColor,
                ),
              ),
              Text(
                surah.numberOfAyahs < 10
                    ? '${surah.numberOfAyahs} ايات'
                    : '${surah.numberOfAyahs} ايه',
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                style: AppFontStyle.balooReg.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Spacer(),
      ],
    );
  }
}
