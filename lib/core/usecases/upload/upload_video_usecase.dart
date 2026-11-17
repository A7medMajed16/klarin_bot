import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../api/client/dio_consumer.dart';
import '../../api/errors/failure.dart';
import '../../utils/base/upload_params.dart';
import '../../utils/base/use_cases.dart';
import 'upload_progress_helper.dart';

@lazySingleton
class UploadVideoUseCase implements StreamUsecase<dynamic, UploadVideoParams> {
  final DioConsumer _api;

  UploadVideoUseCase(this._api);

  @override
  Stream<Either<Failure, dynamic>> call(UploadVideoParams params) =>
      streamUpload<String>(
        apiCall: (onSendProgress) async {
          final result = await _api.uploadVideo(
            videoPath: params.videoPath,
            onSendProgress: onSendProgress,
          );
          return result.toString();
        },
      );
}
