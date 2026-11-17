import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../api/client/dio_consumer.dart';
import '../../api/common/end_points.dart';
import '../../api/errors/failure.dart';
import '../../services/file_service.dart';
import '../../utils/base/download_params.dart';
import '../../utils/base/use_cases.dart';
import '../upload/upload_progress_helper.dart';

@lazySingleton
class DownloadFileUseCase implements StreamUsecase<dynamic, DownloadFileParams> {
  final DioConsumer _api;

  DownloadFileUseCase(this._api);

  String _resolveDownloadUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return '${EndPoints.baseFileUrl}$trimmed';
  }

  String _resolveSaveFileName(DownloadFileParams params) {
    final fromParam = params.fileName?.trim();
    if (fromParam != null && fromParam.isNotEmpty) {
      return fromParam;
    }
    return FileService.getFileName(_resolveDownloadUrl(params.url));
  }

  @override
  Stream<Either<Failure, dynamic>> call(DownloadFileParams params) async* {
    final url = _resolveDownloadUrl(params.url);
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _resolveSaveFileName(params);
    final savePath = p.join(directory.path, fileName);

    yield* streamUpload<String>(
      apiCall: (onReceiveProgress) => _api.downloadFile(
        url: url,
        savePath: savePath,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }
}
