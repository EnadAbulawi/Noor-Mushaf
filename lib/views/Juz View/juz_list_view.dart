import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/views/Juz%20View/widgets/juz_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/juz_controller.dart';
import '../../widgets/custom_loading.dart';
import 'juz_details_view.dart';

class JuzListView extends StatelessWidget {
  final JuzController controller = Get.find<JuzController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return CustomLoading();
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Text(controller.error.value),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.r),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 3.5.w,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final juzNumber = index + 1;

            return JuzCardWidget(
              juzNumber: juzNumber,
              juzName: 'الجزء $juzNumber',
              onTap: () async {
                await controller.loadJuz(juzNumber);
                Get.to(() => JuzDetailsView(juzNumber: juzNumber));
              },
            );
          },
        );
      }),
    );
  }
}
