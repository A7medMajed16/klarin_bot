import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../api/client/dio_consumer.dart';
import '../../api/errors/failure.dart';
import '../../utils/base/upload_params.dart';
import '../../utils/base/use_cases.dart';
import 'upload_progress_helper.dart';

@lazySingleton
class UploadImagesUseCase
    implements StreamUsecase<dynamic, UploadImagesParams> {
  final DioConsumer _api;

  UploadImagesUseCase(this._api);

  @override
  Stream<Either<Failure, dynamic>> call(UploadImagesParams params) async* {
    final paths = params.imagePaths;
    final total = paths.length;
    final results = <String>[];
    double completedProgress = 0.0;

    if (total == 0) {
      yield const Right(<String>[]);
      return;
    }

    final share = 1.0 / total;

    for (int i = 0; i < total; i++) {
      await for (final event in streamUpload<String>(
        apiCall: (onSendProgress) async {
          final result = await _api.uploadImage(
            imagePath: paths[i],
            onSendProgress: onSendProgress,
          );
          return result.toString();
        },
        progressTransform: (p) => completedProgress + (p * share),
      )) {
        if (event.isLeft()) {
          final failure = event.fold((l) => l, (r) => null);
          yield Left(failure!);
          return; // abort on first failure
        } else {
          final data = event.fold((l) => null, (r) => r);
          if (data is double) {
            yield Right(data); // yield progress
          } else if (data is String) {
            results.add(data);
          }
        }
      }
      completedProgress += share;
    }

    // Once all images are successfully uploaded, yield the final list of URLs.
    yield Right(results);
  }
}
