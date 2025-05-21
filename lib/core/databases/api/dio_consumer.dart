import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../errors/expentions.dart';
import 'api_consumer.dart';
import 'end_points.dart';
import 'dart:convert';
import 'dart:typed_data';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ));
  }

  addInterceptors(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

//!POST
  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
    bool isFormData = false,
  }) async {
    try {
      var res = await dio.post(
        options: Options(
          headers: headers,
          extra: extra,
        ),
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

//!GET
  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
    ResponseType? responseType,
  }) async {
    try {
      var res = await dio.get(
        options: Options(
          headers: headers,
          extra: extra,
          responseType: responseType,
        ),
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

//!DELETE
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) async {
    try {
      var res = await dio.delete(
        options: Options(
          headers: headers,
          extra: extra,
        ),
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

//!PATCH
  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    Map<String, dynamic>? extra,
  }) async {
    try {
      var res = await dio.patch(
        options: Options(
          headers: headers,
          extra: extra,
        ),
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future put(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool isFormData = false,
      Map<String, dynamic>? extra}) async {
    try {
      var res = await dio.put(
        options: Options(
          headers: headers,
          extra: extra,
        ),
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}

class CertificatedDio {
  static const sslUrl = 'https://valid-isrgrootx1.letsencrypt.org/';

  /// Creates a Dio instance that works with Let's Encrypt certificates
  /// on older Android devices (Android 7 and below) that don't have the
  /// ISRG Root X1 certificate in their trust store.
  Dio createLetsEncryptDio({String cert = ISRG_X1}) {
    final dio = Dio();

    // Create HttpClient with custom SSL certificates
    HttpClient httpClient = _createCustomHttpClient(cert: cert);

    // Set Dio's HttpClientAdapter to use our custom HttpClient
    dio.httpClientAdapter = _createIOClientAdapter(httpClient);

    return dio;
  }

  /// Creates an HttpClient with custom certificates added to the SecurityContext
  HttpClient _createCustomHttpClient({String? cert}) {
    SecurityContext context = SecurityContext.defaultContext;

    try {
      if (cert != null) {
        Uint8List bytes = utf8.encode(cert);
        context.setTrustedCertificatesBytes(bytes);
      }
      log('createCustomHttpClient() - cert added!');
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          (e.osError?.message.contains('CERT_ALREADY_IN_HASH_TABLE') ??
              false)) {
        log('createCustomHttpClient() - cert already trusted! Skipping.');
      } else {
        log('createCustomHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
        rethrow;
      }
    }

    return HttpClient(context: context);
  }

  /// Creates an IOHttpClientAdapter that uses our custom HttpClient
  IOHttpClientAdapter _createIOClientAdapter(HttpClient httpClient) {
    return IOHttpClientAdapter(
      createHttpClient: () => httpClient,
    );
  }

  /// This is LetsEncrypt's self-signed trusted root certificate authority
  /// certificate, issued under common name: ISRG Root X1 (Internet Security
  /// Research Group). Used in handshakes to negotiate a Transport Layer Security
  /// connection between endpoints. This certificate is missing from older devices
  /// that don't get OS updates such as Android 7 and older.
  ///
  /// PEM format LE self-signed cert from here: https://letsencrypt.org/certificates/
  // ignore: constant_identifier_names
  static const String ISRG_X1 = """-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----""";
}
