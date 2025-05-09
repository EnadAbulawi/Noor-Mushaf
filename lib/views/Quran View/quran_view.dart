import 'package:alfurqan/controllers/data_download_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/views/Quran%20View/widgets/sura_list_view_widget.dart';
import 'package:alfurqan/views/Juz%20View/juz_list_view.dart';
import 'package:alfurqan/views/Hizb%20View/hizb_view.dart';
import 'package:alfurqan/views/widgets/download_data_progress.dart';
import 'package:alfurqan/views/widgets/last_read_widgets.dart';
import 'package:alfurqan/views/widgets/tabBar_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/custom_homeview_appbar.dart';

class QuranMainView extends StatefulWidget {
  @override
  State<QuranMainView> createState() => _QuranMainViewState();
}

class _QuranMainViewState extends State<QuranMainView>
    with SingleTickerProviderStateMixin {
  final SurahController surahController = Get.find();
  final DataDownloadController dataLoadingController = Get.find();
  final SettingsController settingsController = Get.find();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: CustomHomeViewAppBar(
              settingsController: settingsController,
              surahController: surahController,
            ),
          ),
          Obx(() {
            if (!dataLoadingController.isLoading.value) {
              return SizedBox.shrink();
            } else if (dataLoadingController.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DownloadDataProgress(
                    settingsController: settingsController,
                    dataLoadingController: dataLoadingController),
              );
            }
            return SizedBox.shrink();
          }),
          LastReadWidget(
              settingsController: settingsController,
              surahController: surahController),
          SizedBox(height: 10.h),
          TabbarWidget(controller: _tabController),
          SizedBox(height: 10.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SuraListViewWidget(
                    surahController: surahController,
                    settingsController: settingsController),
                JuzListView(),
                // HizbView(),
              ].reversed.toList(),
            ),
          ),
        ],
      ),
    );
  }
}
