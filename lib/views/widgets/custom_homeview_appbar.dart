import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../Quran View/sura_search_delegate.dart';

class CustomHomeViewAppBar extends StatelessWidget {
  final SurahController surahController;
  final SettingsController settingsController;

  const CustomHomeViewAppBar({
    super.key,
    required this.surahController,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SurahSearchDelegate(
                surahs: surahController.surahs,
              ),
            );
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: settingsController.isDarkMode.value
                ? Colors.white
                : Colors.black,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'مصحف نُور',
            style: AppFontStyle.alexandria.copyWith(
              fontSize: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
