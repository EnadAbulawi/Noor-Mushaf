import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

// ✅ تحويل الثواني إلى صيغة دقائق:ثواني
String formatDuration(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return "$minutes:$secs";
}

const showTafseer =
    HugeIcon(icon: HugeIcons.strokeRoundedTextCheck, color: Colors.white);
