part of 'datasource_observer_instances.dart';

final class _SimpleDatasourceObserverImpl implements SimpleDatasourceObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Created', name: 'DS.$name');
  }

  @override
  void onDispose(String name) {
    log('💨 Disposed', name: 'DS.$name');
  }
}

final class _HttpDatasourceObserverImpl implements HttpDatasourceObserver {
  String _tagName(String ds) => 'DS.REMOTE.$ds';

  @override
  void onCreate(String name) {
    log('⛅️ Created', name: _tagName(name));
  }

  @override
  void onDispose(String name) {
    log('💨 Disposed', name: _tagName(name));
  }

  @override
  void onAdmissible(Object? objectResult, {required String datasourceName}) {
    log('✅ Response Admissible', name: _tagName(datasourceName));
  }

  @override
  void onCall(Uri uri, {required String datasourceName, String? body}) {
    log(
      '🔛 CALLING: $uri ${body != null ? "\nBody: $body" : ""}',
      name: _tagName(datasourceName),
    );
  }

  @override
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
  }) {
    log(
      '🚨 UNCONTROLLED ERROR\n'
      'Status: $statusCode\n'
      'Uri: $requestUri\n'
      'Allowed: $admissibleList\n'
      'Response: $body',
      name: _tagName(datasourceName),
    );
  }

  @override
  void onInadmissibleException(
    int statusCode,
    String body,
    Object? response,
    List<int> inadmissibleList, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  }) {
    log(
      '⚠️ INADMISSIBLE RESPONSE\n'
      'Status: $statusCode\n'
      'Uri: $requestUri\n'
      'Body: $body',
      name: _tagName(datasourceName),
    );
  }

  @override
  void onUriCreation(
    String? url,
    Map<String, String> modifyParameters,
    Uri? uri, {
    required String datasourceName,
  }) {
    if (modifyParameters.isNotEmpty) {
      log(
        '💡 URI CREATED: $uri\n'
        'Modifications: $modifyParameters',
        name: _tagName(datasourceName),
      );
    }
  }
}
