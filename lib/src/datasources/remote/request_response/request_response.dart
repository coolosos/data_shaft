/// {@template data_shaft.request_response}
/// A standardized response object returned by [RemoteDriver].
///
/// This class acts as an **Adapter**, encapsulating the response data from any
/// underlying HTTP client (such as Dio, http, or Chopper) into a format
/// that [DatasourceRemote] can process consistently.
/// {@endtemplate}
class RequestResponse<OriginalResponse> {
  /// {@macro data_shaft.request_response}
  const RequestResponse({
    required this.statusCode,
    required this.originalResponse,
    this.body,
    this.headers = const {},
  });

  /// The HTTP status code (e.g., 200, 404, 500).
  ///
  /// This value is typically used by `checkInformation` to determine
  /// if the request was admissible or if an exception should be thrown.
  final int statusCode;

  /// The raw body of the response.
  ///
  /// Usually contains a [String] (JSON/XML) or a decoded [Map]/[List]
  /// depending on how the [RemoteDriver] is configured.
  final String Function()? body;

  /// The HTTP response headers returned by the server.
  final Map<String, String> headers;

  /// The original response object from the underlying library.
  ///
  /// This property holds the raw instance (e.g., `http.Response` or `dio.Response`).
  /// It is highly useful for:
  /// * Debugging and logging.
  /// * Accessing client-specific features not covered by this adapter.
  /// * Advanced manual parsing if needed.
  final OriginalResponse originalResponse;
}
