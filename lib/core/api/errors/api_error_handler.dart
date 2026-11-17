import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../helper/core/app_logger.dart';
import 'failure.dart';

Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.cancel || CancelToken.isCancel(e)) {
      return const Left(RequestCancelledFailure());
    }
    if (e.type == DioExceptionType.connectionError) {
      return left(
        OfflineFailure(
          errorMessage: 'failures.offline_failure'.tr(),
          stackTrace: e.stackTrace,
        ),
      );
    }
    return left(ServerFailure.fromDioException(dioException: e));
  } catch (e, s) {
    AppLogger.error("Unexpected error: $e", stackTrace: s);
    return left(
      ServerFailure(errorMessage: 'failures.unknown_error'.tr(), stackTrace: s),
    );
  }
}
