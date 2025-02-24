import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/hizb_controller.dart';

import '../widgets/hizb_aya_card.dart';

class HizbDetailView extends StatelessWidget {
  final HizbController controller = Get.find();
  final SurahController surahController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() =>
      //       Text('الحزب ${controller.currentHizbQuarter.value?.number ?? ""}')),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.currentHizbQuarter.value == null) {
            return Center(child: Text('لا توجد بيانات'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.currentHizbQuarter.value!.ayahs.length,
            itemBuilder: (context, index) {
              final ayah = controller.currentHizbQuarter.value!.ayahs[index];
              final surah = surahController.surahs[ayah.surahNumber - 1];
              return HizbAyaCard(
                ayah: ayah,
                audioController: Get.find(),
                surahName: surah.name,
              );
            },
          );
        }),
      ),
    );
  }
}
