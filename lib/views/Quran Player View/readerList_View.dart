import 'package:alfurqan/controllers/reader_selection_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class ReaderListView extends StatelessWidget {
  final ReaderSelectionController readerController =
      Get.find<ReaderSelectionController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'القاريء المفضل',
          style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
        ),
      ),
      body: Column(
        children: [
          // إضافة حقل البحث
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: TextField(
              controller: searchController,
              textDirection: TextDirection.rtl,
              style: AppFontStyle.alexandria,
              decoration: InputDecoration(
                hintText: 'ابحث عن قارئ...',
                hintStyle: AppFontStyle.alexandria.copyWith(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(HugeIcons.strokeRoundedSearch01),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
              ),
              onChanged: (value) {
                readerController.searchReader(value);
              },
            ),
          ),
          // قائمة القراء
          Expanded(
            child: Obx(() {
              final readers = readerController.filteredReaders.isEmpty &&
                      searchController.text.isEmpty
                  ? readerController.readers
                  : readerController.filteredReaders;

              if (readers.isEmpty) {
                return Center(
                  child: Text(
                    "لا يوجد قارئ بهذا الاسم",
                    style: AppFontStyle.alexandria,
                  ),
                );
              }
              return ListView.builder(
                  itemCount: readerController.readers.length,
                  itemBuilder: (context, index) {
                    final reader = readers[index];
                    return ListTile(
                      title: Text(
                        reader['name'],
                        style:
                            AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
                      ),
                      trailing: HugeIcon(
                          icon: HugeIcons.strokeRoundedUserCheck02,
                          size: 25.sp,
                          color: AppColor.primaryColor),
                      onTap: () {
                        readerController.selectReader(reader['id'].toString());
                        Get.back();
                      },
                    );
                  });
            }),
          ),
        ],
      ),
    );
  }
}
