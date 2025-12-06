import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/theme/typography.dart';
import '../../core/utils/animate_toast.dart';


class LoggingInterceptor extends dio.Interceptor {
  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {

    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {

    _handleSuccessResponse(response);
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      dio.DioException err, dio.ErrorInterceptorHandler handler) async
  {
    final response = err.response;
    try {
      if (err.type == dio.DioExceptionType.connectionError) {
        _showErrorMessage("No internet connection");
      } else if (err.type == dio.DioExceptionType.connectionTimeout) {

        _showErrorMessage("Connection timed out");
      } else if (response != null) {
        _handleErrorResponse(response);
      } else {
        _showErrorMessage("An unexpected error occurred");
      }
    } catch (e, s) {
      debugPrint("Interceptor Error: ${s.toString()}");
    }

    super.onError(err, handler);
  }

  void _handleSuccessResponse(dio.Response response) {
    switch (response.statusCode) {
      case 200:

        break;
      case 201:

        break;
      case 202:

        break;
      case 204:

        break;
      default:
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          // showMessage(Get.context!,"Operation completed with status ${response.statusCode}", MessageType.success);
        }
    }
  }

  void _handleErrorResponse(dio.Response response) {
    String errorMessage = "An unexpected error occurred";
    switch (response.statusCode) {
      case 400:
        errorMessage = "Bad request: ${response.data['message'] ?? 'Invalid input'}";
        break;
      case 403:
        errorMessage = "${response.data['message'] ?? "Forbidden: You don't have permission"}";
        break;

      case 401:
        errorMessage = "${response.data['message'] ?? "Unauthorized: Please log in again"}";
        break;

        break;
      case 404:
        errorMessage = "${response.data['message'] ?? "Resource not found"}";
        break;
      case 500:
        errorMessage = "Server error: Please try again later";
        break;
      default:
        errorMessage = "${response.data['message'] ?? 'Unknown error'}";
    }
    _showErrorMessage(errorMessage);
  }

  void _showErrorMessage(String message) {
    // showMessage(Get.overlayContext!,message, MessageType.error);
    //
    // // Show Cupertino dialog for long messages
    // if (message.length > 50) {
      showCupertinoDialog(
        context: Get.overlayContext!,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Error ⚠️"),
          content: Text(
            message,
            style: TextStyles.bodyMedium,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    // }
  }

}


