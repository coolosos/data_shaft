import 'dart:convert' show Encoding, utf8;

part 'delete_params.dart';
part 'get_params.dart';
part 'patch_params.dart';
part 'post_params.dart';
part 'put_params.dart';

/// {@template data_shaft.request_params}
/// A base container for all data required to perform a remote request.
///
/// This class encapsulates headers, body encoding logic, query parameters,
/// and client-specific options.
/// {@endtemplate}
sealed class RequestParams {
  /// {@macro data_shaft.request_params}
  const RequestParams({
    this.headers,
    this.encodeBody,
    this.urlParams,
    this.driverOptions,
    this.encoding,
  });

  /// Client-specific configuration (e.g., Dio's `Options` or `CancelToken`).
  ///
  /// Use this to pass parameters that are not part of the standard HTTP request
  /// but are required by your specific `RemoteDriver` implementation.
  final Object? driverOptions;

  /// Custom HTTP headers for the request.
  final Map<String, String>? headers;

  /// A callback that handles the serialization of the request body.
  ///
  /// Usually used to transform a Map or Object into a JSON String, XML,
  /// or any other format required by the server.
  ///
  /// Example:
  /// ```dart
  /// encodeBody: () => json.encode({'name': 'John'})
  /// ```
  final Object? Function()? encodeBody;

  /// The character encoding for the request body. Defaults to [utf8] in most drivers.
  final Encoding? encoding;

  /// Query parameters to be appended to the URL.
  ///
  /// Example:
  /// If [urlParams] is `{'startAt': 'now'}`, the URI will become `api/path?startAt=now`.
  final Map<String, dynamic>? urlParams;
}
