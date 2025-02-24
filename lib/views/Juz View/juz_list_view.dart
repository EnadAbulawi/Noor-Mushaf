import 'package:alfurqan/utils/app_color.dart';
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
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12.r,
            mainAxisSpacing: 12.r,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final juzNumber = index + 1;
            return InkWell(
              onTap: () async {
                await controller.loadJuz(juzNumber);
                Get.to(() => JuzDetailsView(juzNumber: juzNumber));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'الجزء',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '$juzNumber',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
