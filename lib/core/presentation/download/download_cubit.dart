import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../config/classes/state_status.dart';
import '../../config/mixins/safe_emitter.dart';
import '../../usecases/download/download_file_usecase.dart';
import '../../utils/base/download_params.dart';

part 'download_cubit_state.dart';
part 'download_cubit.freezed.dart';

@injectable
class DownloadCubit extends Cubit<DownloadCubitState> with SafeEmitter<DownloadCubitState> {
  DownloadCubit(this._downloadFileUseCase) : super(const DownloadCubitState());

  final DownloadFileUseCase _downloadFileUseCase;

  Future<void> downloadFile({String? url, String? fileName}) async {
    final trimmedUrl = url?.trim();
    if (trimmedUrl == null || trimmedUrl.isEmpty) return;
    if (state.downloadStatus.isLoading) return;

    final displayName = (fileName?.trim().isNotEmpty ?? false)
        ? fileName!.trim()
        : trimmedUrl.split('/').last;

    emit(
      state.copyWith(
        fileName: displayName,
        downloadStatus: StateStatus.loading(progress: 0),
      ),
    );

    await safeEmitUpload<String>(
      stream: _downloadFileUseCase(
        DownloadFileParams(url: trimmedUrl, fileName: fileName),
      ),
      stateField: (status) => state.copyWith(downloadStatus: status),
      onSuccess: (_) => _scheduleReset(),
      onFailure: (_) => _scheduleReset(),
    );
  }

  void _scheduleReset() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        emit(const DownloadCubitState());
      }
    });
  }
}
