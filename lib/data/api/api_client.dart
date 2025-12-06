import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../core/utils/string.dart';
import 'logging_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl, // Replace with your base URL
      connectTimeout:  const Duration(seconds: 30000),
      receiveTimeout:  const Duration(seconds: 10000),
      responseType: ResponseType.json,
    ),
  )..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient:() {
        // if(F.appFlavor==Flavor.prod) {
        //   final client = HttpClient(context: securityContext);
        //   return client;
        // }
        return HttpClient();
      }
  )..interceptors.addAll([
    LoggingInterceptor(),
    PrettyDioLogger(
      requestBody: true,
      enabled: kDebugMode,
      requestHeader: true,
      responseBody: true,

    )
  ]);

  Dio get dio => _dio;
}


