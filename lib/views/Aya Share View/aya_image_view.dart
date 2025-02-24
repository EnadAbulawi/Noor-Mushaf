import 'dart:developer';
import 'package:alfurqan/controllers/tafseer_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/settings_controller.dart';
import 'widgets/app_name.dart';

class AyahScreenshotScreen extends StatefulWidget {
  final String ayahText;
  final String surahName;
  final int ayahNumber;
  final int surahNumber; // إضافة رقم السورة

  AyahScreenshotScreen({
    required this.ayahText,
    required this.surahName,
    required this.ayahNumber,
    required this.surahNumber, // إضافة للمُنشئ
  });

  @override
  _AyahScreenshotScreenState createState() => _AyahScreenshotScreenState();
}

class _AyahScreenshotScreenState extends State<AyahScreenshotScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TafseerController tafseerController = Get.find();
  final SettingsController settingsController = Get.find();
  double _fontSize = 24.0;
  bool _isDarkBackground = false;
  bool _showTafseer = false; // إضافة متغير للتحكم في إظهار/إخفاء التفسير

  double _padding = 16.0;
  double _borderRadius = 10.0;
  Color _borderColor = Colors.transparent;

  void _increaseFontSize() {
    setState(() {
      if (_fontSize < 40.0) _fontSize += 2.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 16.0) _fontSize -= 2.0;
    });
  }

  void _toggleBackgroundColor() {
    setState(() {
      _isDarkBackground = !_isDarkBackground;
    });
  }

  Future<void> _captureAndShare() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      // حفظ الصورة مؤقتًا
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/ayah_screenshot.png').create();
      await file.writeAsBytes(image);

      // مشاركة الصورة
      await Share.shareXFiles([XFile(file.path)], text: 'تطبيق مصحف نور')
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم مشاركة الصورة بنجاح')),
        );
      });
    } catch (e) {
      log('Error capturing screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مشاركة الآية كصورة'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Screenshot(
            controller: _screenshotController,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                color: _isDarkBackground ? AppColor.darkColor : Colors.white,
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.all(
                  color: _borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: IntrinsicWidth(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // إطار اسم السورة
                      Container(
                        height: 42.h,
                        width: double.infinity,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/surahBorder.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.surahName,
                            style: AppFontStyle.uthmanicHafs.copyWith(
                              fontSize: 24.sp,
                              color: _isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // نص الآية مع رقم الآية في النهاية
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                        ),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                          strutStyle: StrutStyle(
                            fontSize: _fontSize,
                          ),
                          text: TextSpan(
                            style: AppFontStyle.kitab.copyWith(
                              fontSize: _fontSize,
                              color: _isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            children: [
                              TextSpan(
                                  text: widget.ayahText,
                                  style: AppFontStyle.kitab.copyWith(
                                    fontSize: _fontSize,
                                    height: 1.5.h,
                                  )),
                              WidgetSpan(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        // vertical: 8.0,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/numberbracket.svg',
                                        color: Color(0xff4477CE),
                                        width: _fontSize <= 26 ? 25 : 35,
                                        height: _fontSize <= 26 ? 25 : 35,
                                      ),
                                    ),
                                    Text(
                                      '${widget.ayahNumber}',
                                      style: AppFontStyle.alexandria.copyWith(
                                        fontSize: 15.sp,
                                        color: _isDarkBackground
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // إضافة التفسير
                      if (_showTafseer) ...[
                        Divider(
                          color: _isDarkBackground
                              ? Colors.white54
                              : Colors.black54,
                          height: 32.h,
                          thickness: 0.2,
                        ),
                        TafseerWidget(
                          isDarkBackground: _isDarkBackground,
                          tafseerController: tafseerController,
                          widget: widget,
                        ),
                      ],

                      SizedBox(height: 40.h),
                      // اسم التطبيق
                      AppName(isDarkBackground: _isDarkBackground),
                      // SizedBox(height: 12.h),
                      // عرض قيمة حجم الخط
                      // Text(
                      //   'حجم الخط: ${_fontSize.toStringAsFixed(1)}',
                      //   style: AppFontStyle.alexandria.copyWith(
                      //     fontSize: 12.sp,
                      //     color:
                      //         _isDarkBackground ? Colors.white : Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                      _showTafseer ? Icons.hide_source_outlined : Icons.book),
                  onPressed: () {
                    setState(() {
                      _showTafseer = !_showTafseer;
                    });
                  },
                ),
                Text('اظهار التفسير',
                    style: AppFontStyle.alexandria.copyWith(fontSize: 12.sp)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(HugeIcons.strokeRoundedPaintBucket),
                  onPressed: _toggleBackgroundColor,
                ),
                Text('لون الخلفية',
                    style: AppFontStyle.alexandria.copyWith(fontSize: 12.sp)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(HugeIcons.strokeRoundedText),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setModalState) => Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                heroTag: 'decrease',
                                onPressed: () {
                                  if (_fontSize > 16.0) {
                                    setModalState(() {
                                      _fontSize -= 2.0;
                                    });
                                    setState(() {});
                                  }
                                },
                                child: Icon(HugeIcons.strokeRoundedRemove01),
                              ),
                              Text(
                                'حجم الخط: ${_fontSize.toStringAsFixed(0)}',
                                style: AppFontStyle.alexandria
                                    .copyWith(fontSize: 12.sp),
                              ),
                              FloatingActionButton(
                                heroTag: 'increase',
                                onPressed: () {
                                  if (_fontSize < 40.0) {
                                    setModalState(() {
                                      _fontSize += 2.0;
                                    });
                                    setState(() {});
                                  }
                                },
                                child: Icon(HugeIcons.strokeRoundedAdd01),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Text('حجم الخط',
                    style: AppFontStyle.alexandria.copyWith(fontSize: 12.sp)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increase',
            onPressed: _captureAndShare,
            child: Icon(HugeIcons.strokeRoundedShare01),
          ),
        ],
      ),
    );
  }
}

class TafseerWidget extends StatelessWidget {
  const TafseerWidget({
    super.key,
    required bool isDarkBackground,
    required this.tafseerController,
    required this.widget,
  }) : _isDarkBackground = isDarkBackground;

  final bool _isDarkBackground;
  final TafseerController tafseerController;
  final AyahScreenshotScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _isDarkBackground
            ? Color(0xff121931).withAlpha(100)
            : Color(0xff7B80AD).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      Get.find<TafseerController>().selectedTafseerName.value,
                      style: AppFontStyle.alexandria.copyWith(
                        fontSize: 14.sp,
                        color: AppColor.primaryColor,
                      ),
                    )),
                Text(
                  'التفسير',
                  style: AppFontStyle.alexandria.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: _isDarkBackground ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Obx(() => FutureBuilder<String>(
                  key: ValueKey(
                      Get.find<TafseerController>().selectedTafseerId.value),
                  future: tafseerController.getAyahTafseer(
                    widget.surahNumber,
                    widget.ayahNumber,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryColor,
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Text(
                        snapshot.data!,
                        style: AppFontStyle.alexandria.copyWith(
                          fontSize: 16.sp,
                          height: 1.8,
                          color: _isDarkBackground
                              ? Colors.white70
                              : Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                      );
                    }
                    return Center(
                      child: Text(
                        'جاري تحميل التفسير...',
                        style: AppFontStyle.alexandria.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
