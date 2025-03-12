import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/audio_Controller.dart';
import '../../controllers/reader_selection_controller.dart';
import 'quran_player_view.dart';
import 'readerList_View.dart';

class QuranSoundView extends StatelessWidget {
  final ReaderSelectionController readerController = Get.find();

  final AudioController audioController = AudioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
        title: Text("صوتيات",
            style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp)),
        centerTitle: true,
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
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryColor,
                      AppColor.secondaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // color: AppColor.primaryColor,
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
                              color: Colors.white,
                              fontSize: 14.sp,
                            )),
                        SizedBox(height: 4.sp),
                        Obx(
                          () => Text(
                            readerController.selectedReaderName.value.isEmpty
                                ? 'لم يتم اخيار قاريء بعد'
                                : readerController.selectedReaderName.value,
                            style: AppFontStyle.alexandria.copyWith(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.sp),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedUserCircle,
                      color: AppColor.lightColor,
                      size: 40.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Obx(() {
            if (readerController.isLoading.value) {
              return Center(
                child: CustomLoading(),
              );
            }

            if (readerController.surahs.isEmpty) {
              return ErrorWidget(readerController: readerController);
            }

            return GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 4 / 1,
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 16.sp,
                                  backgroundColor: AppColor.primaryColor,
                                  child: Text(
                                    '${surah['id']}',
                                    style: AppFontStyle.poppins.copyWith(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                                Text(
                                  'سورة ${surah['name']}',
                                  textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false,
                                  ),
                                  style: AppFontStyle.kitab.copyWith(
                                    fontSize: 25.sp,
                                  ),
                                ),
                              ],
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

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.readerController,
  });

  final ReaderSelectionController readerController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text("لا يمكن تحميل قائمة السور حالياً",
              style: AppFontStyle.alexandria),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () => readerController.loadSurahs(),
            icon: Icon(HugeIcons.strokeRoundedArrowReloadHorizontal, size: 30),
            label: Text("إعادة المحاولة", style: AppFontStyle.alexandria),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(250.w, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp),
              ),
              backgroundColor: AppColor.secondaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
