// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../controllers/tafseer_controller.dart';
// import '../../controllers/settings_controller.dart';

// class TafseerDialog extends StatelessWidget {
//   final int ayahNumber;
//   final TafseerController tafseerController = Get.find();
//   final SettingsController settingsController = Get.find();

//   TafseerDialog({required this.ayahNumber});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.r),
//       ),
//       child: Container(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'التفسير',
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16.h),
//             Obx(() {
//               if (tafseerController.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               if (tafseerController.error.isNotEmpty) {
//                 return Text(
//                   tafseerController.error.value,
//                   style: TextStyle(color: Colors.red),
//                 );
//               }

//               final tafseer = tafseerController.currentTafseer.value;
//               if (tafseer != null) {
//                 return SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         tafseer.text,
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textDirection: TextDirection.rtl,
//                       ),
//                       // Divider(height: 20.h),
//                       // Text(
//                       //   tafseer.tafseer,
//                       //   style: TextStyle(fontSize: 16.sp),
//                       //   textDirection: TextDirection.rtl,
//                       // ),
//                     ],
//                   ),
//                 );
//               }

//               return SizedBox.shrink();
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
