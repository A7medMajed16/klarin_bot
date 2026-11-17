import 'package:freezed_annotation/freezed_annotation.dart';
import '../../api/errors/failure.dart';

part 'state_status.freezed.dart';

@freezed
abstract class StateStatus<T> with _$StateStatus<T> {
  const StateStatus._();

  const factory StateStatus.initial({T? data}) = _Initial;

  const factory StateStatus.loading({
    int? index,
    double? progress,
    DateTime? time,
  }) = _Loading;

  const factory StateStatus.updateUi({T? data, DateTime? time}) =
      _UpdateUi;

  const factory StateStatus.loadingMore({T? data, DateTime? time}) =
      _LoadingMore;

  const factory StateStatus.success({T? data, DateTime? time}) =
      _Success;

  const factory StateStatus.failure({
    required Failure failure,
    DateTime? time,
  }) = _Failure;

  bool get isInitial => this is _Initial;
  bool get isLoading => this is _Loading;
  bool get isLoadingMore => this is _LoadingMore;
  bool get isSuccess => this is _Success;
  bool get isFailure => this is _Failure;

  T? get data => this is _Success
      ? (this as _Success<T>).data
      : (this is _LoadingMore
            ? (this as _LoadingMore<T>).data
            : null);

  double? get progress =>
      this is _Loading ? (this as _Loading<T>).progress : null;

  Failure? get failure =>
      this is _Failure ? (this as _Failure<T>).failure : null;

  int? get index =>
      this is _Loading ? (this as _Loading<T>).index : null;

  String get statusName => map(
    initial: (_) => 'Initial',
    loading: (_) => 'Loading',
    updateUi: (_) => 'UpdateUi',
    loadingMore: (_) => 'LoadingMore',
    success: (_) => 'Success',
    failure: (_) => 'Failure',
  );

  @override
  String toString() => statusName;
}
