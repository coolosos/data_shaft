import 'package:data_shaft/data_shaft.dart';

base class HttpDriver implements RemoteDriver {
  HttpDriver({required this.simulatedResponse});

  final RequestResponse simulatedResponse;

  @override
  Future<RequestResponse> get(
    Uri uri, {
    Map<String, String>? headers,
    Object? options,
  }) async =>
      simulatedResponse;

  @override
  Future<RequestResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;

  @override
  Future<RequestResponse> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;
  @override
  Future<RequestResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;
  @override
  Future<RequestResponse> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      simulatedResponse;

  @override
  Future<RequestResponse> head(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  }) async =>
      simulatedResponse;
}
