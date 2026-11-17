import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../api/client/dio_consumer.dart';
import '../../api/errors/failure.dart';
import '../../utils/base/upload_params.dart';
import '../../utils/base/use_cases.dart';
import 'upload_progress_helper.dart';

@lazySingleton
class UploadAudioUseCase implements StreamUsecase<dynamic, UploadAudioParams> {
  final DioConsumer _api;

  UploadAudioUseCase(this._api);

  @override
  Stream<Either<Failure, dynamic>> call(UploadAudioParams params) =>
      streamUpload<String>(
        apiCall: (onSendProgress) async {
          final result = await _api.uploadAudio(
            audioPath: params.audioPath,
            onSendProgress: onSendProgress,
          );
          return result.toString();
        },
      );
}
