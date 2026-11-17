import 'package:dartz/dartz.dart';

import '../../api/errors/failure.dart';

abstract class Usecase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

abstract class UsecaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

abstract class StreamUsecase<T, P> {
  Stream<Either<Failure, T>> call(P params);
}
