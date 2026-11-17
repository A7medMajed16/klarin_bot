import 'dart:io';

import 'package:dio/dio.dart';

import '../../services/file_service.dart';
import 'api_consumer.dart';
import '../common/end_points.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio});

  dynamic _unwrapData(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  @override
  Future get({
    required String path,
    Options? options,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: queryParameters,
      data: body,
      options: options,
    );
    return _unwrapData(response.data);
  }

  @override
  Future post({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    bool returnFullResponse = false,
  }) async {
    final response = await dio.post(
      path,
      queryParameters: queryParameters,
      data: body,
    );

    return returnFullResponse ? response.data : _unwrapData(response.data);
  }

  @override
  Future put({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.put(
      path,
      data: body,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future patch({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.patch(
      path,
      data: body,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.delete(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response.data;
  }

  @override
  Future uploadVideo({
    required String videoPath,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final response = await dio.post(
      EndPoints.uploadOneFile,
      onSendProgress: onSendProgress,
      data: FormData.fromMap({
        "file": await MultipartFile.fromFile(
          videoPath,
          filename: videoPath.split('/').last,
          contentType: DioMediaType.parse('video/mp4'),
        ),
      }),
    );
    return response.data["name"];
  }

  @override
  Future uploadImage({
    required String imagePath,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final compressedFile = await FileService().compressImage(File(imagePath));
    final finalPath = compressedFile?.path ?? imagePath;

    final response = await dio.post(
      EndPoints.uploadOneImage,
      onSendProgress: onSendProgress,
      data: FormData.fromMap({
        "image": await MultipartFile.fromFile(
          finalPath,
          filename: finalPath.split('/').last,
          contentType: DioMediaType.parse('image/jpeg'),
        ),
      }),
    );
    return response.data["name"];
  }

  @override
  Future uploadImages({
    required List<String> imagePaths,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final List<MultipartFile> multipartImages = await Future.wait(
      imagePaths.map((path) async {
        final compressedFile = await FileService().compressImage(File(path));
        final finalPath = compressedFile?.path ?? path;
        return await MultipartFile.fromFile(
          finalPath,
          filename: finalPath.split('/').last,
          contentType: DioMediaType.parse('image/jpeg'),
        );
      }),
    );

    final response = await dio.post(
      EndPoints.uploadImages,
      onSendProgress: onSendProgress,
      data: FormData.fromMap({"name": multipartImages}),
    );
    return response.data;
  }

  @override
  Future uploadAudio({
    required String audioPath,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final response = await dio.post(
      EndPoints.uploadOneFile,
      onSendProgress: onSendProgress,
      data: FormData.fromMap({
        "file": MultipartFile.fromBytes(
          await File(audioPath).readAsBytes(),
          filename: audioPath.split('/').last,
          contentType: DioMediaType.parse('audio/mpeg'),
        ),
      }),
    );
    return response.data["file"];
  }

  @override
  Future<dynamic> uploadDocument({
    required String documentPath,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final response = await dio.post(
      EndPoints.uploadOneFile,
      onSendProgress: onSendProgress,
      data: FormData.fromMap({
        "file": MultipartFile.fromBytes(
          await File(documentPath).readAsBytes(),
          filename: documentPath.split('/').last,
          contentType: DioMediaType.parse("application/pdf"),
        ),
      }),
    );
    return response.data["file"];
  }

  @override
  Future<String> downloadFile({
    required String url,
    required String savePath,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    await dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
    return savePath;
  }
}
