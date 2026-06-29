part of 'datasource_observer_instances.dart';

/// {@template data_shaft.http_datasource_observer}
/// Interface for monitoring remote interactions.
///
/// This observer captures the entire flow of a remote request:
/// 1. URI creation and parameter modification.
/// 2. The moment the call is triggered.
/// 3. The result (Successful, Inadmissible, or Uncontrolled).
/// {@endtemplate}
abstract interface class HttpDatasourceObserver
    implements SimpleDatasourceObserver {
  /// {@macro data_shaft.http_datasource_observer}
  const HttpDatasourceObserver();

  /// Called when the underlying [RemoteDriver] throws an exception during
  /// the request execution (e.g., network timeout, DNS failure).
  void onDriverException(
    Object error,
    StackTrace stackTrace, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  });

  /// Called when the server returns a status code defined in [inadmissibleStatusCode].
  /// Use this to log expected business errors (e.g., 404 Not Found).
  ///
  /// [inadmissibleStatusCodes] is the set of status codes that the [DatasourceRemote]
  /// considers inadmissible.
  void onInadmissibleException(
    int statusCode,
    String body,
    Object? response,
    Set<int> inadmissibleStatusCodes, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  });

  /// Called when the response is successful and the data has been transformed correctly.
  void onAdmissible(Object? objectResult, {required String datasourceName});

  /// Called when the server returns a status code that is neither admissible nor inadmissible.
  /// This usually indicates unexpected server behavior (e.g., 500 Internal Server Error).
  ///
  /// [inadmissibleStatusCodes] and [admissibleStatusCodes] are the sets configured
  /// in the [DatasourceRemote] that triggered this event.
  void onUnControlException(
    int statusCode,
    String body,
    Object? response,
    Set<int> inadmissibleStatusCodes,
    Set<int> admissibleStatusCodes, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  });

  /// Called after the URI has been constructed, including all path modifications.
  ///
  /// [modifyParameters] contains the path replacement mappings (e.g. `{':id': '123'}`).
  void onUriCreation(
    String? url,
    Map<String, String> modifyParameters,
    Uri? uri, {
    required String datasourceName,
  });

  /// Called just before the [RemoteDriver] executes the request.
  ///
  /// [body] is the serialized request body, if any.
  void onCall(Uri uri, {required String datasourceName, String? body});
}
