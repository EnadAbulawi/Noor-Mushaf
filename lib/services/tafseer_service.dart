import 'dart:developer';
import 'package:dio/dio.dart';

class TafseerService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://api.quran-tafseer.com/tafseer';

  // Future<List<Map<String, dynamic>>> fetchAvailableTafseers() async {
  //   try {
  //     final response = await dio.get('/tafseer');
  //     if (response.statusCode == 200) {
  //       return List<Map<String, dynamic>>.from(response.data);
  //     }
  //     throw 'فشل في تحميل قائمة التفاسير';
  //   } catch (e) {
  //     log('خطأ في تحميل التفاسير: $e');
  //     return [];
  //   }
  // }

  // Future<String> getMuyassarTafseer(int surahNumber, int ayahNumber) async {
  //   try {
  //     final response = await dio.get('/tafseer/1/$surahNumber/$ayahNumber');

  //     if (response.statusCode == 200) {
  //       return response.data['text'] ?? 'التفسير غير متوفر';
  //     }
  //     return 'لا يمكن تحميل التفسير';
  //   } catch (e) {
  //     log('خطأ في تحميل التفسير: $e');
  //     return 'حدث خطأ في تحميل التفسير';
  //   }
  // }

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
