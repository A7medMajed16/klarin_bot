import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../api/errors/failure.dart';
import '../../helper/core/app_logger.dart';
import '../classes/state_status.dart';

mixin SafeEmitter<S> on Cubit<S> {
  /// For simple Freezed union states.
  Future<void> safeEmit<T>({
    required Future<Either<Failure, T>> call,
    required S Function() loading,
    required S Function(T data) success,
    required S Function(Failure failure) failure,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    emit(loading());
    final result = await call;
    result.fold(
      (f) {
        if (f.isCancelled || f is ConnectionServerFailure) {
          return;
        }
        AppLogger.error(
          "[${f.runtimeType}] ${f.errorMessage}",
          stackTrace: f.stackTrace,
        );
        emit(failure(f));
        onFailure?.call(f);
      },
      (data) {
        emit(success(data));
        onSuccess?.call(data);
      },
    );
  }

  Future<void> safeEmitWith<T>({
    required Future<Either<Failure, T>> call,
    required S Function(StateStatus<T> status) stateField,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    int? index,
  }) async {
    emit(stateField(StateStatus.loading(time: DateTime.now(), index: index)));
    final result = await call;
    result.fold(
      (f) {
        if (f.isCancelled || f is ConnectionServerFailure) {
          return;
        }
        AppLogger.error(
          "[${f.runtimeType}] ${f.errorMessage}",
          stackTrace: f.stackTrace,
        );
        if (f is! ConnectionServerFailure) {
          emit(
            stateField(StateStatus.failure(failure: f, time: DateTime.now())),
          );
          onFailure?.call(f);
        }
      },
      (data) {
        if (onSuccess != null) {
          onSuccess.call(data);
        } else {
          emit(
            stateField(StateStatus.success(data: data, time: DateTime.now())),
          );
        }
      },
    );
  }

  Future<void> safeEmitUpload<T>({
    required Stream<Either<Failure, dynamic>> stream,
    required S Function(StateStatus<T> status) stateField,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    await for (final event in stream) {
      event.fold(
        (failure) {
          if (failure.isCancelled || failure is ConnectionServerFailure) {
            return;
          }
          AppLogger.error(
            "[${failure.runtimeType}] ${failure.errorMessage}",
            stackTrace: failure.stackTrace,
          );
          emit(stateField(StateStatus.failure(failure: failure)));
          onFailure?.call(failure);
        },
        (data) {
          if (data is double) {
            emit(stateField(StateStatus.loading(progress: data)));
          } else {
            emit(stateField(StateStatus.success(data: data as T)));
            onSuccess?.call(data);
          }
        },
      );
    }
  }

  Future<void> safeEmitMapped<C, T>({
    required Future<Either<Failure, C>> call,
    required T Function(C data) mapper,
    required S Function(StateStatus<T> status) stateField,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    int? index,
  }) async {
    emit(stateField(StateStatus.loading(time: DateTime.now(), index: index)));
    final result = await call;
    result.fold(
      (f) {
        if (f.isCancelled || f is ConnectionServerFailure) {
          return;
        }
        AppLogger.error(
          "[${f.runtimeType}] ${f.errorMessage}",
          stackTrace: f.stackTrace,
        );
        emit(stateField(StateStatus.failure(failure: f, time: DateTime.now())));
        onFailure?.call(f);
      },
      (data) {
        final mapped = mapper(data);
        if (onSuccess != null) {
          onSuccess.call(mapped);
        } else {
          emit(
            stateField(StateStatus.success(data: mapped, time: DateTime.now())),
          );
        }
      },
    );
  }
}
