import 'dart:developer';

import 'package:alfurqan/services/notification_service.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alfurqan/views/home_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد الصفحة الرئيسية

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
// Define the variable here

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'مرحبًا بك في مصحف نور',
      'description':
          ' تطبيق مصحف نور يوفر لك تجربة قراءة القرآن الكريم بسهولة ويسر واستماع للقران الكريم مع اكثر من 400 قاريء',
      'image': 'assets/quran.png', // صورة توضيحية
    },
    {
      'title': 'مشاركة الاية ك صورة',
      'description':
          'يمكنك مشاركة الاية ك صورة مع تفسيرها ومشاركتها مع اصدقائك او على مواقع التواصل الاجتماعي',
      'image': 'assets/shareaya.png', // صورة توضيحية
    },
    {
      'title': 'الاستماع للاية',
      'description':
          'يمكنك الاستماع للاية التي تقرؤها بصوت الشيخ مشاري العفاسي',
      'image': 'assets/playayah.png', // صورة توضيحية
    },
    {
      'title': 'اضافة الاية للعلامات المرجعية',
      'description':
          'يمكنك من خلال هذا الزر اضافة الاية للعلامات المرجعية مع اكثر من خيار ك خيار المراجعة والحقظ ',
      'image': 'assets/bookmark.png', // صورة توضيحية
    },
    {
      'title': 'تحديد الاية كأخر قراءة وصلت لها',
      'description':
          'يمكنك من خلال هذا الزر اضافة الاية كأخر قراءة وصلت لها لاستكمال القراءة من حيث انتهيت  ',
      'image': 'assets/lastread.png', // صورة توضيحية
    },
    {
      'title': 'تفعيل الموقع',
      'description': 'من فضلك، قم بتفعيل الموقع لحساب أوقات الصلاة بدقة.',
      'image': 'assets/map.png', // صورة توضيحية
    },
    {
      'title': 'تفعيل الإشعارات',
      'description':
          'من فضلك، قم بتفعيل الإشعارات لتلقي تنبيهات بأوقات الصلاة.',
      'image': 'assets/daynotification.png', // صورة توضيحية
    },
  ];

  void _goToNextPage() async {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      Get.off(() => HomeView()); // الانتقال إلى الصفحة الرئيسية
    }
  }

  void _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    Get.off(() => HomeView()); // الانتقال إلى الصفحة الرئيسية
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff040C23), // خلفية بيضاء
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final isLastPage = index == onboardingData.length - 1;
                  final isSecondLastPage = index == onboardingData.length - 2;

                  return OnboardingPage(
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['description']!,
                    image: onboardingData[index]['image']!,
                    onNotificationButtonPressed: isLastPage
                        ? () async {
                            // طلب إذن الإشعارات
                            final status =
                                await Permission.notification.request();
                            if (status.isGranted) {
                              setState(() {
                                showCustomSnackbar(
                                    title: "تنبيه",
                                    message: "تم تفعيل الإشعارات بنجاح.",
                                    backgroundGradient: LinearGradient(
                                      colors: [
                                        Color(0xFFDF98FA),
                                        Color(0xFF9055FF)
                                      ],
                                      begin: Alignment(-0.71, 0.71),
                                      end: Alignment(0.71, -0.71),
                                    ));
                              });
                              NotificationService
                                  .initialize(); // تهيئة الإشعارات
                              log("Notification service initialized.");
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("إذن الإشعارات"),
                                  content: Text(
                                      "يرجى تفعيل الإشعارات لتلقي التنبيهات بأوقات الصلاة."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("موافق"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        : null,
                    onLocationButtonPressed: isSecondLastPage
                        ? () async {
                            // طلب إذن الموقع
                            final status = await Permission.location.request();
                            if (status.isGranted) {
                              setState(() {
                                showCustomSnackbar(
                                    title: "تنبيه",
                                    message:
                                        " تم تفعيل اذن الموقع سيتم الآن حساب أوقات الصلاة بناءً على موقعك.");
                              });

                              // // عرض رسالة تأكيد
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => AlertDialog(
                              //     title: Text("تم تفعيل الموقع"),
                              //     content: Text(
                              //         "سيتم الآن حساب أوقات الصلاة بناءً على موقعك."),
                              //     actions: [
                              //       TextButton(
                              //         onPressed: () => Navigator.pop(context),
                              //         child: Text("موافق"),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            } else {
                              // إذا رفض المستخدم الإذن، عرض رسالة توضيحية
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("إذن الموقع"),
                                  content: Text(
                                      "يرجى تفعيل الموقع لحساب أوقات الصلاة بدقة."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("موافق"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'تخطي',
                      style: AppFontStyle.alexandria.copyWith(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      _currentPage == onboardingData.length - 1
                          ? 'ابدأ'
                          : 'التالي',
                      style: AppFontStyle.alexandria.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColor.secondaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback? onNotificationButtonPressed;
  final VoidCallback? onLocationButtonPressed;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    this.onNotificationButtonPressed,
    this.onLocationButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.contain,
            width: 250.w,
            height: 200.h,
          ),
          SizedBox(height: 24.h),
          Text(
            title,
            style: AppFontStyle.alexandria.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            textDirection: TextDirection.rtl,
            style: AppFontStyle.alexandria.copyWith(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (onNotificationButtonPressed != null ||
              onLocationButtonPressed != null)
            SizedBox(height: 24.h),
          if (onNotificationButtonPressed != null)
            ElevatedButton(
              onPressed: onNotificationButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                "تفعيل الإشعارات",
                style: AppFontStyle.alexandria.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          if (onLocationButtonPressed != null)
            ElevatedButton(
              onPressed: onLocationButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                "تفعيل الموقع",
                style: AppFontStyle.alexandria.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
