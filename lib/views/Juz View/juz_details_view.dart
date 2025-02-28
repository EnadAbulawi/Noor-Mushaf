import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/models/juz_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/juz_controller.dart';
import 'widgets/juz_aya_widget.dart';

class JuzDetailsView extends StatelessWidget {
  final int juzNumber;
  final JuzController controller = Get.find<JuzController>();
  final SettingsController settingsController = Get.find();
  final AudioController audioController = Get.find();
  Ayah? ayah;
  JuzDetailsView({super.key, required this.juzNumber, this.ayah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الجزء $juzNumber',
          style: AppFontStyle.alexandria,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return CustomLoading();
        }

        final juzData = controller.currentJuz.value;
        if (juzData == null) {
          return Center(
            child: Text('لا توجد بيانات متاحة'),
          );
        }

        return JuzAyaWidget(
            juzData: juzData, settingsController: settingsController);
      }),
    );
  }
}
