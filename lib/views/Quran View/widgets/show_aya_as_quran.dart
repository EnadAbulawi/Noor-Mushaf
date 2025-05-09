import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAyaAsQuran extends StatefulWidget {
  const ShowAyaAsQuran({
    super.key,
    required this.surahController,
    required this.settingsController,
  });

  final SurahController surahController;
  final SettingsController settingsController;

  @override
  State<ShowAyaAsQuran> createState() => _ShowAyaAsQuranState();
}

class _ShowAyaAsQuranState extends State<ShowAyaAsQuran> {
  PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadLastPage();
  }

  /// تحميل آخر صفحة تم الوصول إليها
  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPage = prefs.getInt('lastPage') ?? 0;
      _pageController = PageController(initialPage: currentPage);
    });
  }

  /// حفظ آخر صفحة عند تغييرها
  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage', page);
  }

  @override
  Widget build(BuildContext context) {
    List<List<Ayah>> pages = _splitAyahsIntoPages(widget.surahController.ayahs);

    return PageView.builder(
      controller: _pageController,
      reverse: true,
      scrollDirection: Axis.horizontal, // التمرير من اليمين لليسار
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
          _saveLastPage(index);
        });
      },
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return _buildPage(pages[index]);
      },
    );
  }

  /// تقسيم الآيات إلى صفحات، كل صفحة تحتوي على 10 آيات
  List<List<Ayah>> _splitAyahsIntoPages(List<Ayah> ayahs) {
    List<List<Ayah>> pages = [];
    for (int i = 0; i < ayahs.length; i += 10) {
      pages.add(
          ayahs.sublist(i, (i + 10) > ayahs.length ? ayahs.length : (i + 10)));
    }
    return pages;
  }

  /// بناء الصفحة لعرض 10 آيات متراصة
  Widget _buildPage(List<Ayah> ayahs) {
    return Column(
      children: [
        // إطار اسم السورة
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            height: 40.h,
            width: double.infinity,
            // margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/surah8.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Text(
                widget.surahController.currentSurah.value.name,
                style: AppFontStyle.kitab,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        // عرض الآيات متراصة كما في المصحف
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 6.h, bottom: 14.h, right: 16.w, left: 16.w),
              child: Obx(
                () => RichText(
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    style: AppFontStyle.kitab.copyWith(
                        fontSize: widget.settingsController.fontSize.value,
                        color: widget.settingsController.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                        height: 1.7, // ضبط المسافات كما في المصحف
                        overflow: TextOverflow.visible,
                        letterSpacing: ayahs.isEmpty ? 0 : 0.10.w),
                    children: _buildAyaText(ayahs),
                  ),
                ),
              ),
            ),
          ),
        ),

        // تذييل الصفحة
        // _buildPageFooter(ayahs),
        // LinearProgressIndicator(
        //   value: (currentPage + 1) /
        //       _splitAyahsIntoPages(widget.surahController.ayahs).length,
        //   backgroundColor: Colors.grey.shade300,
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        // )
      ],
    );
  }

  /// بناء نصوص الآيات داخل `RichText`
  List<TextSpan> _buildAyaText(List<Ayah> ayahs) {
    final settingsController = Get.find<SettingsController>();
    return ayahs.map((ayah) {
      return TextSpan(
        children: [
          TextSpan(
            text: ayah.text,
            style: AppFontStyle.kitab.copyWith(
              fontSize: widget.settingsController.fontSize.value,
            ),
          ),
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/numberbracket.svg',
                    color: const Color(0xff5c745c),
                    width:
                        settingsController.fontSize.value >= 28 ? 33.w : 25.w,
                    height:
                        settingsController.fontSize.value >= 28 ? 33.w : 25.w,
                  ),
                  Text(
                    '${ayah.number}',
                    style: AppFontStyle.uthmanicHafs.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  /// تذييل الصفحة
  Widget _buildPageFooter(List<Ayah> ayahs) {
    final firstAyah = ayahs.isNotEmpty ? ayahs.first : null;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFooterItem('الصفحة', '${firstAyah?.page ?? 0}'),
          _buildFooterItem('الجزء', '${firstAyah?.juz ?? 0}'),
          _buildFooterItem('الحزب', '${firstAyah?.hizbQuarter ?? 0}'),
        ],
      ),
    );
  }

  /// عنصر تذييل الصفحة
  Widget _buildFooterItem(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: widget.settingsController.isDarkMode.value
                ? Colors.white
                : Colors.black,
          ),
        ),
      ],
    );
  }
}
