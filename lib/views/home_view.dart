import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/views/BookMark%20View/bookmark_view.dart';
import 'package:alfurqan/views/salahTime%20View/salah_time_home.dart';
import 'package:alfurqan/views/settings_view.dart';
import 'package:alfurqan/widgets/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Quran Player View/quran_sound_view.dart';
import 'Quran View/quran_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SettingsController settingsController = Get.find();
  final RxInt _currentIndex = 4.obs;

  // تحديث قائمة الصفحات
  final List<Widget> _pages = [
    SettingsView(),
    BookmarksView(),
    SalahTimeHome(),
    QuranSoundView(),
    QuranMainView(), // الصفحة الرئيسية
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsController.isDarkMode.value
          ? AppColor.darkColor
          : AppColor.lightColor,
      body: Obx(() => _pages[_currentIndex.value]),
      bottomNavigationBar: Obx(() => CustomBottomNavigation(
            currentIndex: _currentIndex.value,
            onTap: (index) {
              _currentIndex.value = index;
            },
          )),
    );
  }
}
