import 'package:alfurqan/controllers/data_download_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/tafseer_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatelessWidget {
  final SettingsController settingsController = Get.find();
  final DataDownloadController dataLoadingController = Get.find();
  final TafseerController controller = Get.put(TafseerController());

// دالة عرض قائمة التفاسير
  Future<void> _showTafseerSelector(BuildContext context) async {
    final TafseerController tafseerController = Get.find();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // إضافة هذا
      builder: (context) => Container(
        height: Get.height * 0.7, // تحديد ارتفاع ثابت
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // تحسين التنسيق
              children: [
                Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedBook01, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'اختر مصدر التفسير',
                      style: AppFontStyle.alexandria.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    tafseerController.fetchAvailableTafseers();
                  },
                  icon: Icon(Icons.refresh),
                  tooltip: 'تحديث قائمة التفاسير',
                ),
              ],
            ),
            Divider(height: 24.h),
            Expanded(
              child: Obx(() {
                if (tafseerController.isLoading.value) {
                  // إضافة حالة التحميل
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // if (tafseerController.error.value.isNotEmpty) {
                //   // إضافة حالة الخطأ
                //   return Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(tafseerController.error.value),
                //         ElevatedButton(
                //           onPressed: tafseerController.fetchAvailableTafseers,
                //           child: Text('إعادة المحاولة'),
                //         ),
                //       ],
                //     ),
                //   );
                // }

                return ListView.builder(
                  itemCount: tafseerController.availableTafseers.length,
                  itemBuilder: (context, index) {
                    final tafseer = tafseerController.availableTafseers[index];
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      child: ListTile(
                        title: Text(
                          tafseer['name'],
                          style: AppFontStyle.alexandria,
                        ),
                        trailing: Obx(() => Radio<String>(
                              value: tafseer['id'].toString(),
                              groupValue:
                                  tafseerController.selectedTafseerId.value,
                              onChanged: (value) {
                                tafseerController.setSelectedTafseer(value!);
                                //تحديثص الواجهة عند الرجوع

                                Get.back();
                              },
                            )),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

// ... existing code ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: AppFontStyle.balooBold.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'المظهر',
                [
                  // Dark Mode Card
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 12.r),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        children: [
                          Icon(Icons.dark_mode, color: AppColor.primaryColor),
                          SizedBox(width: 12.w),
                          Text(
                            'الوضع الليلي',
                            style: AppFontStyle.balooBold
                                .copyWith(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Obx(() => Switch(
                                value: settingsController.isDarkMode.value,
                                onChanged: settingsController.toggleDarkMode,
                                activeColor: AppColor.primaryColor,
                              )),
                        ],
                      ),
                    ),
                  ),

                  // Font Size Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.text_fields,
                                  color: AppColor.primaryColor),
                              SizedBox(width: 12.w),
                              Text(
                                'حجم الخط',
                                style: AppFontStyle.balooBold
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Obx(() => Column(
                                children: [
                                  Slider(
                                    value: settingsController.fontSize.value,
                                    min: 16.0.sp,
                                    max: 40.0.sp,
                                    activeColor: AppColor.primaryColor,
                                    onChanged:
                                        settingsController.updateFontSize,
                                  ),
                                  Text(
                                    'حجم الخط: ${settingsController.fontSize.value.toStringAsFixed(1)}',
                                    style: AppFontStyle.balooBold
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.2)),
                                    ),
                                    child: Text(
                                      'صلي على رسول الله',
                                      style: AppFontStyle.balooBold.copyWith(
                                        fontSize:
                                            settingsController.fontSize.value,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildSection(
                'التنزيلات',
                [
                  // Quran Data Card
                  _buildSettingCard(
                    icon: Icons.update,
                    title: "إعادة تحميل بيانات القرآن",
                    subtitle:
                        Text("إذا كنت تواجه مشاكل، يمكنك إعادة تحميل البيانات"),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await dataLoadingController.downloadAllSurahs();
                        Get.snackbar(
                            "نجاح", "تم إعادة تحميل بيانات القرآن بنجاح");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text("إعادة التحميل"),
                    ),
                  ),

                  // Audio Download Card
                  _buildSettingCard(
                    icon: Icons.audio_file,
                    title: "تحميل الصوتيات",
                    subtitle: Obx(() => Text(
                          dataLoadingController.isAudioDownloaded.value
                              ? "تم تحميل جميع الصوتيات 🎵"
                              : dataLoadingController.isAudioLoading.value
                                  ? "جاري التحميل... ${(dataLoadingController.audioProgress.value * 100).toStringAsFixed(1)}%"
                                  : "اضغط لاستئناف التحميل من ${(dataLoadingController.audioProgress.value * 100).toStringAsFixed(1)}%",
                        )),
                    trailing: dataLoadingController.isAudioLoading.value
                        ? CircularProgressIndicator(
                            color: AppColor.primaryColor)
                        : Icon(Icons.download, color: AppColor.primaryColor),
                    onTap: () async {
                      // Existing audio download logic
                    },
                  ),
                ],
              ),
              _buildSection(
                'التفسير',
                [
                  _buildSettingCard(
                    icon: HugeIcons.strokeRoundedBook01,
                    title: 'مصدر التفسير',
                    subtitle: Obx(() => Text(
                          settingsController.getCurrentTafseerName(),
                          style: AppFontStyle.alexandria
                              .copyWith(color: Colors.grey),
                        )),
                    onTap: () => _showTafseerSelector(context),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton.icon(
                  onPressed: settingsController.resetSettings,
                  icon: Icon(Icons.restore),
                  label: Text('إعادة تعيين الإعدادات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     controller.fetchAvailableTafseers(); // جلب التفاسير
              //   },
              //   child: Text('تحميل التفاسير'),
              // ),
              // Obx(() {
              //   if (controller.availableTafseers.isEmpty) {
              //     return Center(child: CircularProgressIndicator());
              //   }

              //   return ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: controller.availableTafseers.length,
              //     itemBuilder: (context, index) {
              //       final tafseer = controller.availableTafseers[index];
              //       return ListTile(
              //         title: Text(tafseer['name']),
              //         onTap: () {
              //           controller.setSelectedTafseer(tafseer['id'].toString());
              //         },
              //       );
              //     },
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.r),
          child: Text(
            title,
            style: AppFontStyle.balooBold.copyWith(
              fontSize: 18.sp,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        ...children,
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required Widget subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.r),
        leading: Icon(icon, color: AppColor.primaryColor),
        title: Text(title, style: AppFontStyle.alexandria),
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
