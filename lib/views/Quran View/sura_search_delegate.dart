import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/utils/removeDiacritics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import 'sura_detail_view.dart';

class SurahSearchDelegate extends SearchDelegate<String> {
  final List<Surah> surahs;

  SurahSearchDelegate({required this.surahs});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedClean,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowLeft01,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: _filterSurahs(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("حدث خطأ أثناء البحث"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("لا توجد نتائج مطابقة"));
        } else {
          final filteredSurahs = snapshot.data!;
          return ListView.builder(
            itemCount: filteredSurahs.length,
            itemBuilder: (context, index) {
              Surah surah = filteredSurahs[index];
              return ListTile(
                title: Text(surah.name,
                    style: AppFontStyle.uthmanicHafs.copyWith(fontSize: 18)),
                onTap: () {
                  Get.back();
                  final surahController = Get.find<SurahController>();
                  surahController.setCurrentSurah(surah);
                  surahController.fetchAyahs(surah.id);
                  Get.to(() => SurahDetailView());
                },
              );
            },
          );
        }
      },
    );
  }

  Future<List<Surah>> _filterSurahs(String query) async {
    await Future.delayed(Duration(milliseconds: 300)); // محاكاة تأخير الشبكة
    String normalizedQuery = normalizeArabicText(query);
    return surahs.where((surah) {
      String normalizedSurahName = normalizeArabicText(surah.name);
      return normalizedSurahName.contains(normalizedQuery);
    }).toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String normalizedQuery = normalizeArabicText(query);

    final suggestions = surahs.where((surah) {
      String normalizedSurahName = normalizeArabicText(surah.name);
      String normalizedSurahTranslation =
          normalizeArabicText(surah.englishNameTranslation);

      return normalizedSurahName.contains(normalizedQuery) ||
          normalizedSurahTranslation.contains(normalizedQuery);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Surah surah = suggestions[index];

        return ListTile(
          title: Text(surah.name,
              style: AppFontStyle.uthmanicHafs.copyWith(fontSize: 22.sp)),
          subtitle: Text(surah.englishNameTranslation,
              style: AppFontStyle.poppins.copyWith(fontSize: 12.sp)),
          onTap: () {
            query = surah.name;
            showResults(context);
          },
        );
      },
    );
  }
}
