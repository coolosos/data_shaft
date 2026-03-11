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

  @mustCallSuper
  void onDriverException(
    Object error,
    StackTrace stackTrace, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  });

  /// Called when the server returns a status code defined in `inadmissibleStatusCode`.
  /// Use this to log expected business errors (e.g., 404 Not Found).
  @mustCallSuper
  void onInadmissibleException(
    int statusCode,
    String body,
    Object? response,
    List<int> inadmissibleList, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  });

  /// Called when the response is successful and the data has been transformed correctly.
  @mustCallSuper
  void onAdmissible(Object? objectResult, {required String datasourceName});

  /// Called when the server returns a status code that is neither admissible nor inadmissible.
  /// This usually indicates unexpected server behavior (e.g., 500 Internal Server Error).
  @mustCallSuper
  void onUnControlException(
    int statusCode,
    String body,
    Object? response,
    List<int> inadmissibleList,
    List<int> admissibleList, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  });

  /// Called after the URI has been constructed, including all path modifications.
  @mustCallSuper
  void onUriCreation(
    String? url,
    Map<String, String> modifyParameters,
    Uri? uri, {
    required String datasourceName,
  });

  /// Called just before the [RemoteDriver] executes the request.
  @mustCallSuper
  void onCall(Uri uri, {required String datasourceName, String? body});
}
