import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppName extends StatelessWidget {
  const AppName({
    super.key,
    required bool isDarkBackground,
  }) : _isDarkBackground = isDarkBackground;

  final bool _isDarkBackground;

  @override
  Widget build(BuildContext context) {
    return Text(
      'تطبيق مصحف نور',
      style: AppFontStyle.alexandria.copyWith(
        fontSize: 12.sp,
        color: _isDarkBackground ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
