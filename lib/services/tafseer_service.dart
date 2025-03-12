import 'dart:developer';
import 'package:dio/dio.dart';

class TafseerService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://api.quran-tafseer.com/tafseer';

  Future<String> getTafseerById(
      String tafseerId, int surahNumber, int ayahNumber) async {
    try {
      final response =
          await _dio.get('$baseUrl/$tafseerId/$surahNumber/$ayahNumber');
      if (response.statusCode == 200) {
        return response.data['text'];
      }
      throw Exception('فشل في جلب التفسير');
    } catch (e) {
      log('Error fetching tafseer: $e');
      throw Exception('خطأ في جلب التفسير');
    }
  }
}
