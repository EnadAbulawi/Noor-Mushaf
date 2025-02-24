import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/juz_controller.dart';
import '../../controllers/quran_player_controller.dart';

class JuzDetailsView extends StatelessWidget {
  final int juzNumber;
  final JuzController controller = Get.find<JuzController>();

  JuzDetailsView({required this.juzNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الجزء $juzNumber'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return CustomLoading();
        }

        final juzData = controller.currentJuz.value;
        if (juzData == null) {
          return Center(
            child: Text('لا توجد بيانات متاحة'),
          );
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'معلومات الجزء',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'من ${juzData.startSurahName} إلى ${juzData.endSurahName}',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: juzData.verses.length,
                itemBuilder: (context, index) {
                  final verse = juzData.verses[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.r),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                verse.surahName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 4.r,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'آية ${verse.number}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            verse.text,
                            style: AppFontStyle.kitab.copyWith(
                              fontSize: 20.sp,
                              height: 1.8,
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
