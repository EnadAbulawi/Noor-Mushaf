import 'package:alfurqan/controllers/bookmark_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/models/bookmark_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class BookmarkButton extends StatelessWidget {
  final Ayah ayah;
  final SurahController surahController;
  final BookmarkController bookMarkController;

  const BookmarkButton({
    Key? key,
    required this.ayah,
    required this.surahController,
    required this.bookMarkController,
  }) : super(key: key);

  void _handleBookmark() {
    final bookmark = BookmarkModel(
      surahNumber: surahController.currentSurah.value.id,
      ayahNumber: ayah.number,
      surahName: surahController.currentSurah.value.name,
      ayahText: ayah.text,
      dateAdded: DateTime.now(),
      category: 'للقراءة',
    );

    if (_isBookmarked) {
      bookMarkController.removeBookmark(bookmark);
      Get.snackbar(
        'تم الإزالة',
        'تمت إزالة الآية من العلامات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      _showBookmarkDialog(bookmark);
    }
  }

  bool get _isBookmarked => bookMarkController.bookmarks.any((b) =>
      b.surahNumber == surahController.currentSurah.value.id &&
      b.ayahNumber == ayah.number);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleBookmark,
      icon: Obx(() => HugeIcon(
            icon: _isBookmarked
                ? HugeIcons.strokeRoundedBookmarkOff02
                : HugeIcons.strokeRoundedBookmark02,
            color: _isBookmarked ? Color(0xffF9B091) : AppColor.primaryColor,
            size: 23,
          )),
    );
  }

  void _showBookmarkDialog(BookmarkModel bookmark) {
    final categories = ['للقراءة', 'للحفظ', 'للمراجعة', 'للتدبر', 'مفضلة'];

    Get.defaultDialog(
      title: 'إضافة إلى المحفوظات',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: categories
            .map((category) => ListTile(
                  title: Text(category),
                  onTap: () {
                    final newBookmark = BookmarkModel(
                      surahNumber: bookmark.surahNumber,
                      ayahNumber: bookmark.ayahNumber,
                      surahName: bookmark.surahName,
                      ayahText: bookmark.ayahText,
                      dateAdded: bookmark.dateAdded,
                      category: category,
                    );
                    bookMarkController.addBookmark(newBookmark);
                    Get.back();
                    Get.snackbar(
                      'تمت الإضافة',
                      'تمت إضافة الآية إلى المحفوظات',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
