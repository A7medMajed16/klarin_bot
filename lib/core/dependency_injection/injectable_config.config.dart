// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../api/client/dio_consumer.dart' as _i651;
import '../presentation/download/download_cubit.dart' as _i610;
import '../theme/theme_cubit/theme_cubit.dart' as _i613;
import '../usecases/download/download_file_usecase.dart' as _i901;
import '../usecases/upload/upload_audio_usecase.dart' as _i958;
import '../usecases/upload/upload_document_usecase.dart' as _i363;
import '../usecases/upload/upload_image_usecase.dart' as _i811;
import '../usecases/upload/upload_images_usecase.dart' as _i947;
import '../usecases/upload/upload_video_usecase.dart' as _i115;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreInjectableModule = _$CoreInjectableModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreInjectableModule.prefs,
      preResolve: true,
    );
    gh.factory<_i613.ThemeCubit>(() => _i613.ThemeCubit());
    gh.singleton<_i361.Dio>(() => coreInjectableModule.dio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => coreInjectableModule.secureStorage,
    );
    gh.singleton<_i651.DioConsumer>(
      () => coreInjectableModule.dioConsumer(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i901.DownloadFileUseCase>(
      () => _i901.DownloadFileUseCase(gh<_i651.DioConsumer>()),
    );
    gh.lazySingleton<_i958.UploadAudioUseCase>(
      () => _i958.UploadAudioUseCase(gh<_i651.DioConsumer>()),
    );
    gh.lazySingleton<_i363.UploadDocumentUseCase>(
      () => _i363.UploadDocumentUseCase(gh<_i651.DioConsumer>()),
    );
    gh.lazySingleton<_i811.UploadImageUseCase>(
      () => _i811.UploadImageUseCase(gh<_i651.DioConsumer>()),
    );
    gh.lazySingleton<_i947.UploadImagesUseCase>(
      () => _i947.UploadImagesUseCase(gh<_i651.DioConsumer>()),
    );
    gh.lazySingleton<_i115.UploadVideoUseCase>(
      () => _i115.UploadVideoUseCase(gh<_i651.DioConsumer>()),
    );
    gh.factory<_i610.DownloadCubit>(
      () => _i610.DownloadCubit(gh<_i901.DownloadFileUseCase>()),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}
