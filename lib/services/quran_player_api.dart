import 'dart:developer';

import 'package:dio/dio.dart';

enum ApiStatus {
  success,
  serverError,
  networkError,
  timeout,
}

class ApiResponse<T> {
  final T? data;
  final ApiStatus status;
  final String message;

  ApiResponse({
    this.data,
    required this.status,
    required this.message,
  });
}

class QuranPlayerApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://mp3quran.net/api/v3/',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));

  Future<ApiResponse<List<Map<String, dynamic>>>> getReciters() async {
    int retryCount = 3;
    while (retryCount > 0) {
      try {
        final response = await _dio.get('reciters?language=ar');
        if (response.statusCode == 200) {
          final reciters = List<Map<String, dynamic>>.from(response.data['reciters']);
          reciters.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
          
          return ApiResponse(
            data: reciters,
            status: ApiStatus.success,
            message: 'تم جلب القراء بنجاح',
          );
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout) {
          log('⏳ انتهت مهلة الاتصال بالخادم');
          return ApiResponse(
            status: ApiStatus.timeout,
            message: 'عذراً، الخادم لا يستجيب حالياً. الرجاء المحاولة لاحقاً',
          );
        } else if (e.type == DioExceptionType.connectionError) {
          log('📡 خطأ في الاتصال بالإنترنت');
          return ApiResponse(
            status: ApiStatus.networkError,
            message: 'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى',
          );
        }
        
        log('❌ خطأ في الخادم: $e');
        retryCount--;
        await Future.delayed(Duration(seconds: 5));
      }
    }
    
    return ApiResponse(
      status: ApiStatus.serverError,
      message: 'عذراً، الخادم غير متاح حالياً. سيتم إصلاح المشكلة قريباً',
    );
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getSurahs() async {
    try {
      final response = await _dio.get('suwar?language=ar');
      if (response.statusCode == 200) {
        return ApiResponse(
          data: List<Map<String, dynamic>>.from(response.data['suwar']),
          status: ApiStatus.success,
          message: 'تم جلب السور بنجاح',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse(
          status: ApiStatus.timeout,
          message: 'عذراً، الخادم لا يستجيب حالياً. الرجاء المحاولة لاحقاً',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse(
          status: ApiStatus.networkError,
          message: 'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى',
        );
      }
    }
    
    return ApiResponse(
      status: ApiStatus.serverError,
      message: 'عذراً، الخادم غير متاح حالياً. سيتم إصلاح المشكلة قريباً',
    );
  }
}
