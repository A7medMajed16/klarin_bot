part of 'download_cubit.dart';

@freezed
abstract class DownloadCubitState with _$DownloadCubitState {
  const factory DownloadCubitState({
    @Default('') String fileName,
    @Default(StateStatus<String>.initial())
    StateStatus<String> downloadStatus,
  }) = _DownloadCubitState;
}
