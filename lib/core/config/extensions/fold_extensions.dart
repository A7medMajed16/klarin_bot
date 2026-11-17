import 'package:dartz/dartz.dart';

import '../../api/errors/failure.dart';
import '../classes/state_status.dart';

extension FolderHandler<T> on Either<Failure, T> {
  StateStatus<T> toStateStatus({
    StateStatus<T> Function(T data)? onSuccess,
    StateStatus<T> Function(Failure failure)? onFailure,
  }) {
    return fold(
      (failure) => onFailure != null
          ? onFailure(failure)
          : StateStatus.failure(
              failure: failure,
              time: DateTime.now(),
            ),
      (data) => onSuccess != null
          ? onSuccess(data)
          : StateStatus.success(data: data, time: DateTime.now()),
    );
  }

  void handle({
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onFailure,
  }) {
    fold((failure) => onFailure(failure), (data) => onSuccess(data));
  }
}
