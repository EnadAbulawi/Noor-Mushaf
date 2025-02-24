import 'dart:developer';

import 'package:dio/dio.dart';

class QuranPlayerApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://mp3quran.net/api/v3/',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));
  Future<List<Map<String, dynamic>>> getReciters() async {
    int retryCount = 3; // ⬅️ عدد المحاولات قبل إيقاف العملية
    while (retryCount > 0) {
      try {
        final response = await _dio.get('reciters?language=ar');
        if (response.statusCode == 200) {
          return List<Map<String, dynamic>>.from(response.data['reciters']);
        }
      } catch (e) {
        log('❌ محاولة فاشلة لجلب القُرّاء، تبقى $retryCount محاولات...');
        retryCount--;
        await Future.delayed(
            Duration(seconds: 5)); // ⬅️ انتظار 5 ثوانٍ قبل المحاولة التالية
      }
    }
    log('❌ جميع المحاولات فشلت.');
    return [];
  }

  Future<List<Map<String, dynamic>>> getSurahs() async {
    try {
      final response = await _dio.get('suwar?language=ar');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['suwar']);
      }
    } catch (e) {
      log('❌ خطأ أثناء جلب السور: $e');
    }
    return [];
  }
}
