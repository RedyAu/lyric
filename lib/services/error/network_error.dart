import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

const _networkDioExceptionTypes = <DioExceptionType>{
  DioExceptionType.connectionTimeout,
  DioExceptionType.sendTimeout,
  DioExceptionType.receiveTimeout,
  DioExceptionType.connectionError,
  DioExceptionType.badCertificate,
};

bool isNetworkRelatedError(Object? error) {
  if (error == null) {
    return false;
  }

  if (error is DioException) {
    return _networkDioExceptionTypes.contains(error.type) ||
        isNetworkRelatedError(error.error);
  }

  return error is SocketException ||
      error is TimeoutException ||
      error is HandshakeException ||
      error is TlsException;
}

bool isRetryableDioException(DioException error) {
  if (isNetworkRelatedError(error)) {
    return true;
  }

  if (error.type == DioExceptionType.badResponse) {
    final statusCode = error.response?.statusCode;
    return statusCode != null && statusCode >= 500;
  }

  return false;
}
