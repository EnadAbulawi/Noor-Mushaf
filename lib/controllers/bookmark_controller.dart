import 'dart:convert';
import 'dart:developer';
import 'package:alfurqan/views/Quran%20View/sura_detail_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark_model.dart';

class BookmarkController extends GetxController {
  final RxList<BookmarkModel> bookmarks = <BookmarkModel>[].obs;
  final RxString selectedCategory = 'الكل'.obs;

  final categories = [
    'الكل',
    'للحفظ',
    'للمراجعة',
    'للقراءة',
    'للتدبر',
    'مفضلة',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  @override
  void onClose() {
    bookmarks.clear();
    super.onClose();
  }

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarksJson = prefs.getString('bookmarks');

      if (bookmarksJson != null) {
        final List<dynamic> decoded = jsonDecode(bookmarksJson);
        bookmarks.value =
            decoded.map((item) => BookmarkModel.fromJson(item)).toList();
      }
    } catch (e) {
      log('Error loading bookmarks: $e');
      bookmarks.clear();
    }
  }

  Future<void> addBookmark(BookmarkModel bookmark) async {
    bookmarks.add(bookmark);
    await saveBookmarks();
  }

  Future<void> removeBookmark(BookmarkModel bookmark) async {
    bookmarks.remove(bookmark);
    await saveBookmarks();
  }

  Future<void> saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        bookmarks.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('bookmarks', encodedData);
    } catch (e) {
      log('Error saving bookmarks: $e');
    }
  }

  List<BookmarkModel> getFilteredBookmarks() {
    if (selectedCategory.value == 'الكل') {
      return bookmarks;
    }
    return bookmarks
        .where((bookmark) => bookmark.category == selectedCategory.value)
        .toList();
  }

  // navigateToAyah
  void navigateToAyah(BookmarkModel bookmark) {
    Get.to(() => SurahDetailView(
          initialAyahNumber: bookmark.ayahNumber,
        ));
  }
}
