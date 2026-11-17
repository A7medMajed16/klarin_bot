import 'package:dio/dio.dart';

import '../../cache/storage/cache_helper.dart';
import '../../helper/core/app_logger.dart';
import '../../helper/formatters/user_helper.dart';
import '../../utils/constants/app_cache_keys.dart';
import '../common/end_points.dart';
import '../common/status_code.dart';

class AppInterceptors extends QueuedInterceptor {
  final Dio dio;

  AppInterceptors({required this.dio});

  Future<bool>? _refreshFuture;

  /// Tracks in-flight GET requests for automatic cancellation.
  final Map<String, CancelToken> _activeRequests = {};

  static const _skipRefreshKey = 'skipAuthRefresh';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.method.toUpperCase() == 'GET') {
      final requestKey = options.path;

      if (_activeRequests.containsKey(requestKey)) {
        _activeRequests[requestKey]?.cancel('cancel');
      }

      final cancelToken = CancelToken();
      options.cancelToken = cancelToken;
      _activeRequests[requestKey] = cancelToken;
    }

    final authToken = await FSS.getString(key: AppCacheKeys.accessToken);
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET') {
      final requestKey = response.requestOptions.path;
      if (_activeRequests[requestKey] == response.requestOptions.cancelToken) {
        _activeRequests.remove(requestKey);
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.method.toUpperCase() == 'GET') {
      final requestKey = err.requestOptions.path;
      if (_activeRequests[requestKey] == err.requestOptions.cancelToken) {
        _activeRequests.remove(requestKey);
      }
    }

    // Cancelled requests are expected (e.g. superseded GET) — do not treat as app error.
    if (err.type == DioExceptionType.cancel || CancelToken.isCancel(err)) {
      return handler.next(err);
    }

    final statusCode = err.response?.statusCode;
    AppLogger.error('AppInterceptor.onError: statusCode=$statusCode');

    if (statusCode == StatusCode.expiredToken) {
      if (_shouldSkipRefresh(err.requestOptions)) {
        _forceLogout();
        return handler.reject(err);
      }

      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        try {
          final response = await _retry(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }

      _forceLogout();
      return handler.reject(err);
    }

    if (statusCode == StatusCode.unauthorized ||
        statusCode == StatusCode.forbidden) {
      _forceLogout();
    }

    return handler.next(err);
  }

  bool _shouldSkipRefresh(RequestOptions options) {
    if (options.extra[_skipRefreshKey] == true) return true;
    return options.path.contains(EndPoints.refreshToken);
  }

  Future<bool> _tryRefreshToken() {
    return _refreshFuture ??= _doRefreshToken().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<bool> _doRefreshToken() async {
    try {
      final refreshToken = await FSS.getString(key: AppCacheKeys.refreshToken);
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await dio.post(
        '${EndPoints.apiUrl}${EndPoints.refreshToken}',
        data: {'token': refreshToken},
        options: Options(extra: {_skipRefreshKey: true}),
      );

      final newToken = response.data['accessToken'] as String?;
      if (newToken == null || newToken.isEmpty) return false;

      await FSS.setString(value: newToken, key: AppCacheKeys.accessToken);
      return true;
    } on DioException catch (e) {
      AppLogger.error('Token refresh failed: ${e.response?.statusCode}');
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await FSS.getString(key: AppCacheKeys.accessToken);
    final options = requestOptions.copyWith(
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );
    return dio.fetch(options);
  }

  void _forceLogout() {
    UserHelper.clearUserData();
  }
}
