import 'package:alfurqan/controllers/AudioController.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/reader_selection_controller.dart';
import 'quran_player_view.dart';
import 'readerList_View.dart';

class QuranSoundView extends StatelessWidget {
  final ReaderSelectionController readerController =
      Get.find(); // ✅ استخدام Get.find فقط

  final AudioController audioController = AudioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صوتيات",
            style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp)),
        centerTitle: true,
        // backgroundColor: Colors.green[700], // ✅ تحسين الألوان
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () => Get.to(() => ReaderListView()),
              borderRadius: BorderRadius.circular(12.sp),
              child: Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: Colors.green[100], // ✅ تحسين الألوان
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('قارئك المفضل',
                            style: AppFontStyle.alexandria.copyWith(
                              color: Colors.black,
                              fontSize: 14.sp,
                            )),
                        Obx(
                          () => Text(
                            readerController.selectedReaderName.value.isEmpty
                                ? 'لم يتم اخيار قاريء بعد'
                                : readerController.selectedReaderName.value,
                            style: AppFontStyle.alexandria.copyWith(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.sp),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedUserCircle,
                      color: AppColor.darkColor,
                      size: 40.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Obx(() {
            if (readerController.surahs.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: readerController.surahs.length,
                itemBuilder: (context, index) {
                  final surah = readerController.surahs[index];
                  return InkWell(
                    onTap: () {},
                    child: InkWell(
                      onTap: () {
                        if (readerController.selectedReader.value.isNotEmpty) {
                          int surahNumber = surah['id'];
                          Get.to(() => QuranPlayerView(), arguments: {
                            'surahNumber': surahNumber,
                            'surahName': surah['name'],
                            'reader': readerController.selectedReaderName.value
                          });
                        } else {
                          Get.snackbar(
                            "⚠️ تنبيه",
                            "يرجى اختيار القارئ أولًا",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Center(
                          child: Text(
                            'سورة ${surah['name']}',
                            textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                            ),
                            style: AppFontStyle.newQuran.copyWith(
                              fontSize: 25.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          })),
        ],
      ),
    );
  }
}
