import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/controllers/bookmark_controller.dart';

class BookmarksView extends GetView<BookmarkController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
        title: Text('المحفوظات'),
      ),
      body: Column(
        children: [
          Container(
            height: 50.h,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                return Obx(() {
                  final category = controller.categories[index];
                  final isSelected =
                      controller.selectedCategory.value == category;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(category),
                      onSelected: (selected) {
                        controller.selectedCategory.value = category;
                      },
                      selectedColor: AppColor.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppColor.primaryColor,
                    ),
                  );
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredBookmarks = controller.getFilteredBookmarks();
              if (filteredBookmarks.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد محفوظات',
                    style: AppFontStyle.alexandria.copyWith(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: filteredBookmarks.length,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) {
                  final bookmark = filteredBookmarks[index];
                  return Dismissible(
                    key: Key(bookmark.dateAdded.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => controller.removeBookmark(bookmark),
                    child: Card(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        onTap: () {
                          // Navigate to ayah
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    bookmark.surahName,
                                    style: AppFontStyle.alexandria.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'آية ${bookmark.ayahNumber}',
                                    style: AppFontStyle.alexandria.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  Spacer(),
                                  Chip(
                                    label: Text(
                                      bookmark.category,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    backgroundColor:
                                        AppColor.primaryColor.withOpacity(0.1),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                bookmark.ayahText,
                                style: AppFontStyle.kitab.copyWith(
                                  fontSize: 18.sp,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
