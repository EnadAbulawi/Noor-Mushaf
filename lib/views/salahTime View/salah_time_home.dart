import 'dart:developer';
import 'package:alfurqan/controllers/prayer_times_controller.dart';
import 'package:alfurqan/features/athanPlayer.dart';
import 'package:alfurqan/features/customCard.dart';
import 'package:alfurqan/services/notification_service.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class SalahTimeHome extends StatefulWidget {
  const SalahTimeHome({super.key});

  @override
  _SalahTimeHomeState createState() => _SalahTimeHomeState();
}

class _SalahTimeHomeState extends State<SalahTimeHome> {
  final PrayerTimesController controller = Get.put(PrayerTimesController());

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // final hijri = HijriCalendar.fromDate(now);

    return Scaffold(
      backgroundColor: Get.isDarkMode ? AppColor.darkColor : AppColor.dayColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,

        // centerTitle: true,
        backgroundColor:
            Get.isDarkMode ? AppColor.darkColor : AppColor.dayColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedPrayerRug01,
              color: AppColor.secondaryColor,
              size: 25.w,
            ),
            Spacer(),
            Text("أوقات الصلاة", style: AppFontStyle.alexandria),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.play_arrow),
        //     onPressed: () {
        //       AthanPlayer.playAthan();
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.stop),
        //     onPressed: () {
        //       AthanPlayer.stopAthan();
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.notification_important),
        //     onPressed: () {
        //       NotificationService.showNotification("الفجر");
        //       AthanPlayer.playAthan();
        //     },
        //   ),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CustomLoading());
        }
        if (controller.locationPermissionDenied.value) {
          return _buildPermissionDeniedWidget();
        }
        if (!controller.isLocationServiceEnabled.value) {
          return _buildLocationServiceDisabled();
        }
        if (controller.prayerTimes.value == null) {
          return Center(child: Text("❌ لم يتم العثور على أوقات الصلاة"));
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.secondaryColor,
                      Colors.deepPurpleAccent.shade400
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    // ✅ التاريخ الهجري والميلادي
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          //show hijri date in arabic
                          "${HijriCalendar.fromDate(now).toFormat("dd MMMM yyyy")} هـ",
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                        // SizedBox(width: 8.w),
                        // Text(
                        //   DateFormat.yMMMMd('ar').format(now),
                        //   style: AppFontStyle.alexandria.copyWith(
                        //     fontSize: 18.sp,
                        //     color: Colors.white70,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // ✅ الصلاة القادمة والوقت المتبقي
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.nextPrayer.value,
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 20.sp,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.h),
                        Text(
                          "الصلاة القادمة",
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    StreamBuilder<String>(
                      stream: controller.remainingTimeStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Text("--:--:--",
                              style: AppFontStyle.alexandria.copyWith(
                                  fontSize: 30.sp, color: Colors.white));
                        }
                        log("Snapshot data: ${snapshot.data}");
                        return Text(
                          snapshot.data!,
                          style: AppFontStyle.alexandria
                              .copyWith(fontSize: 30.sp, color: Colors.white),
                        );
                      },
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '📍${controller.location.value.split(",")[0]}',
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 14.sp,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          "حسب توقيت",
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ قائمة أوقات الصلاة
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchPrayerTimes(),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  children: [
                    buildPrayerCard(
                      "الفجر",
                      controller.prayerTimes.value?.fajr,
                      'assets/alfajr.svg',
                    ),
                    buildPrayerCard(
                      "الشروق",
                      controller.prayerTimes.value?.sunrise,
                      'assets/Dhuha.svg',
                    ),
                    buildPrayerCard(
                      "الظهر",
                      controller.prayerTimes.value?.dhuhr,
                      'assets/Dhuhur.svg',
                    ),
                    buildPrayerCard(
                      "العصر",
                      controller.prayerTimes.value?.asr,
                      'assets/Asr.svg',
                    ),
                    buildPrayerCard(
                      "المغرب",
                      controller.prayerTimes.value?.maghrib,
                      'assets/Maghrib.svg',
                    ),
                    buildPrayerCard(
                      "العشاء",
                      controller.prayerTimes.value?.isha,
                      'assets/Isha.svg',
                    ),
                    buildPrayerCard(
                      "الثلث الاول",
                      controller.prayerTimes.value?.firstThird,
                      'assets/qyam.svg',
                    ),
                    buildPrayerCard(
                      "الثلث الاخر",
                      controller.prayerTimes.value?.lastThird,
                      'assets/qyam.svg',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPermissionDeniedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "⚠️ يجب منح إذن الموقع لحساب أوقات الصلاة",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.checkLocationPermission(),
            child: Text("🔄 طلب الإذن"),
          ),
        ],
      ),
    );
  }

  Widget buildPrayerCard(String prayerName, String? prayerTime, String image) {
    final isNextPrayer = controller.nextPrayer.value == prayerName;
    String displayTime = prayerTime ?? "--:--";
    displayTime = controller.convertTo12Hour(displayTime);

    return CustomCard(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [AppColor.secondaryColor, Colors.teal.shade700],
            // begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
            colors: isNextPrayer
                ? [AppColor.secondaryColor, Colors.deepPurpleAccent.shade400]
                : [Colors.grey.shade200, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          leading: SvgPicture.asset(
            image,
            height: 32.h,
            color: isNextPrayer ? Colors.white : Colors.black87,
          ),

          // icon,
          // size: 32,
          // color: isNextPrayer ? Colors.white : Colors.black87,

          title: Text(
            prayerName,
            style: AppFontStyle.alexandria.copyWith(
                fontSize: 20.sp,
                color: isNextPrayer ? Colors.white : Colors.black87,
                fontWeight: isNextPrayer ? FontWeight.bold : FontWeight.normal),
          ),
          trailing: Text(
            displayTime,
            style: AppFontStyle.alexandria.copyWith(
                fontSize: 18,
                color: isNextPrayer ? Colors.white : Colors.black87,
                fontWeight: isNextPrayer ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  // 🔹 شاشة عند تعطيل خدمات الموقع
  Widget _buildLocationServiceDisabled() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Lottie Animation
            Lottie.asset('assets/location.json', height: 250.h, width: 250.w),
            SizedBox(height: 20.h),
            Text(
              "خدمات الموقع معطلة",
              style: AppFontStyle.alexandria.copyWith(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "لعرض أوقات الصلاة يجب عليك تفعيل خدمات الموقع الخاصة بجهازك من خلال الضغط على الزر الذي بالأسفل ثم تفعيل خدمات الموقع",
              textAlign: TextAlign.center,
              style: AppFontStyle.alexandria.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () async {
                // فتح إعدادات الموقع
                await Geolocator.openLocationSettings();

                // التحقق من حالة خدمات الموقع بعد العودة
                bool serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (serviceEnabled) {
                  // تحديث حالة خدمات الموقع
                  controller.isLocationServiceEnabled.value = true;

                  // جلب أوقات الصلاة
                  await controller.fetchPrayerTimes();
                } else {
                  // إذا لم يتم تفعيل خدمات الموقع، نعيد عرض نفس الشاشة
                  Get.snackbar(
                    "خطأ",
                    "لم يتم تفعيل خدمات الموقع",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text("تفعيل خدمات الموقع", style: AppFontStyle.alexandria),
            ),
          ],
        ),
      ),
    );
  }
}
