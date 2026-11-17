import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get({
    required String path,
    Options? options,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> post({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> put({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });
  Future<dynamic> uploadImage({
    required String imagePath,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<dynamic> uploadImages({
    required List<String> imagePaths,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<dynamic> uploadVideo({
    required String videoPath,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<dynamic> uploadAudio({
    required String audioPath,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<dynamic> uploadDocument({
    required String documentPath,
    void Function(int sent, int total)? onSendProgress,
  });
  Future<String> downloadFile({
    required String url,
    required String savePath,
    void Function(int received, int total)? onReceiveProgress,
  });
}
