import 'package:data_shaft/data_shaft.dart';

base class HttpDriver implements RemoteDriver<Object?> {
  HttpDriver({required this.simulatedResponse});

  final RequestResponse<Object?> simulatedResponse;

  @override
  Future<RequestResponse<Object?>> get(
    Uri uri, {
    Map<String, String>? headers,
    Object? options,
  }) async =>
      simulatedResponse;

  @override
  Future<RequestResponse<Object?>> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;

  @override
  Future<RequestResponse<Object?>> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;
  @override
  Future<RequestResponse<Object?>> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;
  @override
  Future<RequestResponse<Object?>> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;

  @override
  Future<RequestResponse<Object?>> head(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  }) async =>
      simulatedResponse;
}
