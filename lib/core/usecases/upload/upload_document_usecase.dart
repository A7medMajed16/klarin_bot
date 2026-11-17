import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../api/client/dio_consumer.dart';
import '../../api/errors/failure.dart';
import '../../utils/base/upload_params.dart';
import '../../utils/base/use_cases.dart';
import 'upload_progress_helper.dart';

@lazySingleton
class UploadDocumentUseCase
    implements StreamUsecase<dynamic, UploadDocumentParams> {
  final DioConsumer _api;

  UploadDocumentUseCase(this._api);

  @override
  Stream<Either<Failure, dynamic>> call(UploadDocumentParams params) =>
      streamUpload<String>(
        apiCall: (onSendProgress) async {
          final result = await _api.uploadDocument(
            documentPath: params.documentPath,
            onSendProgress: onSendProgress,
          );
          return result.toString();
        },
      );
}
