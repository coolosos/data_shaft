import 'dart:async';
import 'dart:convert';

import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/request_response/request_response.dart';

class MockModel extends Codable<String, MockModel> {
  const MockModel({required this.name});

  factory MockModel.fromJson(String body) {
    final map = json.decode(body) as Map<String, dynamic>;
    return MockModel(name: map['name'] as String);
  }
  final String name;

  MockModel copyWith({String? name}) => MockModel(name: name ?? this.name);

  Map<String, dynamic> toJson() => {'name': name};

  @override
  MockModel decode(String remote) {
    return MockModel.fromJson(remote);
  }

  @override
  List<Object?> get props => [name];

  @override
  JsonCodec? get serializer => throw UnimplementedError();

  @override
  Encoding? get encoding => throw UnimplementedError();
}

class MockRemoteDriver implements RemoteDriver<Object?> {
  RequestResponse<Object?>? simulatedResponse;
  Error? throwable;
  Uri? lastUri;
  Object? lastBody;
  Map<String, String>? lastHeaders;

  @override
  Future<RequestResponse<Object?>> get(
    Uri uri, {
    Map<String, String>? headers,
    Object? options,
  }) async {
    lastUri = uri;
    lastHeaders = headers;
    if (throwable case final throwable?) {
      throw throwable;
    }
    return simulatedResponse!;
  }

  @override
  Future<RequestResponse<Object?>> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async {
    lastUri = uri;
    lastBody = body;
    lastHeaders = headers;
    if (throwable case final throwable?) {
      throw throwable;
    }
    return simulatedResponse!;
  }

  @override
  Future<RequestResponse<Object?>> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      post(uri, body: body, headers: headers);
  @override
  Future<RequestResponse<Object?>> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      post(uri, body: body, headers: headers);
  @override
  Future<RequestResponse<Object?>> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  }) async =>
      post(uri, body: body, headers: headers);

  @override
  Future<RequestResponse<Object?>> head(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  }) =>
      post(url, body: null, headers: headers);
}
