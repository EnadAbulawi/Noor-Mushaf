import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alfurqan/models/juz_model.dart';
import 'package:alfurqan/models/hizb_model.dart';
import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class ApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  // جلب قائمة السور
  // جلب قائمة السور
  Future<List<Surah>> getSurahs() async {
    final data = await _get('surah');
    if (data != null && data['data'] != null) {
      return (data['data'] as List)
          .map((surahJson) => Surah.fromJson(surahJson))
          .toList();
    } else {
      throw Exception('Invalid data structure for surahs');
    }
  }

  // دالة عامة لتنفيذ الطلبات
  Future<dynamic> _get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // جلب آيات سورة معينة
  Future<List<Ayah>> getAyahs(int surahNumber) async {
    try {
      final response = await _dio.get('/surah/$surahNumber/ar.alafasy');
      if (response.statusCode == 200 && response.data != null) {
        final List ayahsData = response.data['data']['ayahs'];
        return ayahsData
            .map((ayah) => Ayah.fromJson({
                  'number': ayah['numberInSurah'],
                  'text': ayah['text'],
                  'surahNumber': surahNumber,
                  'audio': ayah['audio'],
                }))
            .toList();
      }
      throw Exception('فشل في جلب الآيات');
    } catch (e) {
      log('Error in getAyahs: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // جلب الجزء
  Future<JuzModel> getJuz(int juzNumber) async {
    try {
      final response = await _dio.get('/juz/$juzNumber/ar.alafasy');
      if (response.statusCode == 200) {
        return JuzModel.fromJson(response.data['data']);
      }
      throw Exception('فشل في جلب بيانات الجزء');
    } catch (e) {
      log('Error in getJuz: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // جلب الصفحة

  // جلب ربع حزب معين
  Future<HizbQuarter> getHizbQuarter(int quarterNumber) async {
    try {
      final response = await _dio.get('/hizbQuarter/$quarterNumber/ar.alafasy');
      if (response.statusCode == 200 && response.data != null) {
        return HizbQuarter.fromJson(response.data['data']);
      }
      throw Exception('فشل في جلب الحزب');
    } catch (e) {
      log('Error in getHizbQuarter: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // جلب قائمة الأحزاب
  Future<List<HizbQuarter>> getAllHizbQuarters() async {
    try {
      final List<HizbQuarter> hizbQuarters = [];
      // إنشاء 60 ربع حزب (8 أحزاب × 4 أرباع)
      for (int i = 1; i <= 60; i++) {
        hizbQuarters.add(HizbQuarter(
          number: i,
          ayahs: [],
        ));
      }
      return hizbQuarters;
    } catch (e) {
      log('Error in getAllHizbQuarters: $e');
      throw Exception('خطأ في الاتصال: $e');
    }
  }
}
