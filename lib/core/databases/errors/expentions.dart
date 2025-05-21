import 'package:dio/dio.dart';

import '../api/end_points.dart';
import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnprocessableContentException extends ServerException {
  UnprocessableContentException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel.fromJson({
        'message':
            'تعذر الاتصال. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
      }));

    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson({
        'message': 'هناك مشكلة في شهادة أمان الخادم. يرجى المحاولة لاحقًا.',
      }));

    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel.fromJson({
        'message':
            'انتهت مهلة الاتصال. يرجى التحقق من الإنترنت والمحاولة مرة أخرى.',
      }));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson({
        'message': 'الخادم يستغرق وقتًا طويلاً للرد. يرجى المحاولة بعد قليل.',
      }));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson({
        'message': 'انتهت مهلة الطلب أثناء الإرسال. يرجى المحاولة مرة أخرى.',
      }));

    case DioExceptionType.cancel:
      throw CancelException(ErrorModel.fromJson({
        'message':
            'تم إلغاء الطلب. إذا لم تكن أنت من ألغاه، يرجى المحاولة مرة أخرى.',
      }));

    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel.fromJson({
        'message':
            'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى أو التواصل مع الدعم.',
      }));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request

          throw BadResponseException(ErrorModel.fromJson(e.response!.data));

        case 401: //unauthorized
          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data));

        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));

        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));

        case 409: //cofficient

          throw CofficientException(ErrorModel.fromJson(e.response!.data));

        case 422: //Unprocessable Content
          throw UnprocessableContentException(
              ErrorModel.fromJson(e.response!.data));

        case 504: // Bad request

          throw BadResponseException(
              ErrorModel(errorMessage: e.response!.data));
      }
  }
}
