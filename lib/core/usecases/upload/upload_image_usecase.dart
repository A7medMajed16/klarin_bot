import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../api/client/dio_consumer.dart';
import '../../api/errors/failure.dart';

import '../../utils/base/upload_params.dart';
import '../../utils/base/use_cases.dart';
import 'upload_progress_helper.dart';

@lazySingleton
class UploadImageUseCase implements StreamUsecase<dynamic, UploadImageParams> {
  final DioConsumer _api;

  UploadImageUseCase(this._api);

  @override
  Stream<Either<Failure, dynamic>> call(UploadImageParams params) =>
      streamUpload<String>(
        apiCall: (onSendProgress) async {
          final result = await _api.uploadImage(
            imagePath: params.imagePath,
            onSendProgress: onSendProgress,
          );
          return result.toString();
        },
      );
}
