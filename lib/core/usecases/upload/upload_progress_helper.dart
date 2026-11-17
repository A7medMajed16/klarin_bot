import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../api/errors/failure.dart';

Stream<Either<Failure, dynamic>> streamUpload<T>({
  required Future<T> Function(void Function(int sent, int total) onSendProgress)
  apiCall,
  double Function(double rawProgress)? progressTransform,
}) async* {
  final progressController = StreamController<Either<Failure, dynamic>>();

  // Fire the upload; push each progress tick into the controller
  final uploadFuture =
      apiCall((sent, total) {
        final raw = total > 0 ? sent / total : 0.0;
        final mapped = progressTransform?.call(raw) ?? raw;
        if (!progressController.isClosed) progressController.add(Right(mapped));
      }).whenComplete(() {
        // Close the progress stream once the HTTP request is fully done
        if (!progressController.isClosed) progressController.close();
      });

  // Stream all progress events (doubles) to the consumer
  yield* progressController.stream;

  // Now await the actual HTTP response and yield the final result
  try {
    final result = await uploadFuture;
    yield Right(result);
  } on DioException catch (e) {
    yield Left(ServerFailure.fromDioException(dioException: e));
  } catch (e) {
    yield Left(CustomFailure(errorMessage: e.toString()));
  }
}
