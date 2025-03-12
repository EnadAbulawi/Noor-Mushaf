import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alfurqan/views/home_view.dart'; // استيراد الصفحة الرئيسية

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
      'title': 'تحديد آخر قراءة',
      'description': 'احفظ آخر موضع قراءة وعد إليه في أي وقت.',
      'image': 'assets/shareaya.png', // صورة توضيحية
    },
  ];

  void _goToNextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      Get.off(() => HomeView()); // الانتقال إلى الصفحة الرئيسية
    }
  }

  void _skipOnboarding() {
    Get.off(() => HomeView()); // الانتقال إلى الصفحة الرئيسية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
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
                  return OnboardingPage(
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['description']!,
                    image: onboardingData[index]['image']!,
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
                      backgroundColor: AppColor.secondaryColor, // لون الزر
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // زوايا منحنية
                      ),
                      elevation: 5, // ظل ناعم
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

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
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
            // width: 400.w,
            // height: 200.h,
          ),
          SizedBox(height: 24.h),
          Text(
            title,
            style: AppFontStyle.alexandria.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
        ],
      ),
    );
  }
}
