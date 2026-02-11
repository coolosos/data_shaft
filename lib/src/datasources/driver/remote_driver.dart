import 'dart:convert';

import 'package:data_shaft/src/datasources/remote/request_response/request_response.dart';

import 'driver.dart';

/// {@template data_shaft.remote_driver}
/// An abstract interface that defines the contract for HTTP communication.
///
/// This driver decouples the [DatasourceRemote] from the underlying HTTP client implementation
/// (e.g., `http`, `dio`, `graphql`). It provides explicit methods for standard HTTP verbs
/// to facilitate debugging and clearer stack traces.
/// {@endtemplate}
abstract interface class RemoteDriver extends Driver {
  /// {@macro data_shaft.remote_driver}
  const RemoteDriver();

  /// Sends an HTTP HEAD request.
  ///
  /// Useful for retrieving headers without transferring the entire body.
  ///
  /// - [url]: The target URI.
  /// - [headers]: Optional HTTP headers.
  /// - [options]: Extra configuration specific to the underlying client implementation
  ///   (e.g., `dio.Options`, timeouts, cancel tokens).
  Future<RequestResponse> head(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  });

  /// Sends an HTTP GET request to retrieve data.
  ///
  /// - [url]: The target URI.
  /// - [headers]: Optional HTTP headers.
  /// - [options]: Extra configuration specific to the underlying client implementation.
  Future<RequestResponse> get(
    Uri url, {
    Map<String, String>? headers,
    Object? options,
  });

  /// Sends an HTTP POST request to submit data.
  ///
  /// - [url]: The target URI.
  /// - [headers]: Optional HTTP headers.
  /// - [body]: The payload to send. Can be a Map, List, or raw String.
  /// - [encoding]: The encoding to use for the body (defaults to UTF-8 in most clients).
  /// - [options]: Extra configuration specific to the underlying client implementation.
  Future<RequestResponse> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  });

  /// Sends an HTTP PUT request to replace a resource.
  ///
  /// - [url]: The target URI.
  /// - [headers]: Optional HTTP headers.
  /// - [body]: The payload to replace the resource with.
  /// - [encoding]: The encoding to use for the body.
  /// - [options]: Extra configuration specific to the underlying client implementation.
  Future<RequestResponse> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  });

  /// Sends an HTTP PATCH request to modify a resource partially.
  ///
  /// - [url]: The target URI.
  /// - [headers]: Optional HTTP headers.
  /// - [body]: The payload containing the changes.
  /// - [encoding]: The encoding to use for the body.
  /// - [options]: Extra configuration specific to the underlying client implementation.
  Future<RequestResponse> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  });

  /// Sends an HTTP DELETE request to remove a resource.
  ///
  /// - [url]: The target URI.
  /// - [headers]: Optional HTTP headers.
  /// - [body]: Optional payload (some APIs require a body for deletion).
  /// - [encoding]: The encoding to use for the body.
  /// - [options]: Extra configuration specific to the underlying client implementation.
  Future<RequestResponse> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Object? options,
  });
}
