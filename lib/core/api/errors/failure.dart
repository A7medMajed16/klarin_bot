import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

/// Base class for all application failures.
///
/// Each failure carries a translated [errorMessage] ready for display.
abstract class Failure extends Equatable {
  final String errorMessage;
  final StackTrace? stackTrace;

  const Failure({required this.errorMessage, this.stackTrace});

  /// Whether this failure represents an intentional request cancellation.
  bool get isCancelled => this is RequestCancelledFailure;

  @override
  List<Object?> get props => [errorMessage, stackTrace];
}

class ConnectionServerFailure extends ServerFailure {
  const ConnectionServerFailure({required super.errorMessage});
}

/// Request was cancelled (CancelToken). Should never surface as a UI error.
class RequestCancelledFailure extends ServerFailure {
  const RequestCancelledFailure() : super(errorMessage: '');
}

/// Failure originating from server/network operations.
class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage, super.stackTrace});

  /// Maps a [DioException] to the appropriate [ServerFailure]
  /// with a localized error message.
  factory ServerFailure.fromDioException({required DioException dioException}) {
    final st = dioException.stackTrace;
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errorMessage: 'failures.connection_timeout'.tr(),
          stackTrace: st,
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(
          errorMessage: 'failures.send_timeout'.tr(),
          stackTrace: st,
        );

      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          errorMessage: 'failures.receive_timeout'.tr(),
          stackTrace: st,
        );

      case DioExceptionType.transformTimeout:
        return ServerFailure(
          errorMessage: 'failures.transform_timeout'.tr(),
          stackTrace: st,
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          errorMessage: 'failures.bad_certificate'.tr(),
          stackTrace: st,
        );

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          statusCode: dioException.response?.statusCode,
          response: dioException.response?.data,
          stackTrace: st,
        );

      case DioExceptionType.cancel:
        // Intentional cancel (e.g. superseded GET) — not an error for UI.
        return const RequestCancelledFailure();

      case DioExceptionType.connectionError:
        return ServerFailure(
          errorMessage: 'failures.no_internet'.tr(),
          stackTrace: st,
        );

      case DioExceptionType.unknown:
        return ServerFailure(
          errorMessage: 'failures.unknown_error'.tr(),
          stackTrace: st,
        );
    }
  }

  /// Maps an HTTP response status code to the appropriate [ServerFailure].
  ///
  /// For client errors (400, 401, 404, 409, 422, 424), uses the server's
  /// `message` field if available; otherwise falls back to a translated default.
  factory ServerFailure.fromResponse({
    int? statusCode,
    dynamic response,
    StackTrace? stackTrace,
  }) {
    final serverMessage = _extractServerMessage(response);

    switch (statusCode) {
      case 400:
      case 401:
      case 404:
      case 409:
      case 422:
      case 424:
        return ServerFailure(
          errorMessage: serverMessage ?? 'failures.unexpected_error'.tr(),
          stackTrace: stackTrace,
        );

      case 403:
        return ServerFailure(
          errorMessage: 'failures.session_expired'.tr(),
          stackTrace: stackTrace,
        );

      case 500:
        return ServerFailure(
          errorMessage: 'failures.internal_server_error'.tr(),
          stackTrace: stackTrace,
        );

      default:
        return ServerFailure(
          errorMessage: serverMessage ?? 'failures.unknown_response_error'.tr(),
          stackTrace: stackTrace,
        );
    }
  }

  /// Safely extracts the `message` field from a server response.
  static String? _extractServerMessage(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response['message'] as String?;
    }
    return null;
  }
}

/// Failure when device has no internet connection.
class OfflineFailure extends Failure {
  const OfflineFailure({required super.errorMessage, super.stackTrace});
}

/// Failure when local cache operations fail.
class CacheFailure extends Failure {
  const CacheFailure({required super.errorMessage, super.stackTrace});
}

/// Failure when location services are unavailable or denied.
class LocationFailure extends Failure {
  const LocationFailure({required super.errorMessage, super.stackTrace});
}

/// Generic failure for custom/domain-specific errors.
class CustomFailure extends Failure {
  const CustomFailure({required super.errorMessage, super.stackTrace});
}
