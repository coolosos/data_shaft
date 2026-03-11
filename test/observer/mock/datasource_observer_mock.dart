import 'dart:developer';

import 'package:data_shaft/data_shaft.dart';

final class CustomRemoteObserver extends CustomDatasourceObserver
    implements HttpDatasourceObserver {
  int isOnAdmissible = 0;
  int isOnCall = 0;
  int isOnDriverException = 0;
  int isOnInadmissibleException = 0;
  int isOnUnControlException = 0;
  int isOnUriCreation = 0;
  @override
  void onAdmissible(Object? objectResult, {required String datasourceName}) {
    isOnAdmissible = isOnAdmissible + 1;
  }

  @override
  void onCall(Uri uri, {required String datasourceName, String? body}) {
    isOnCall = isOnCall + 1;
  }

  @override
  void onDriverException(
    Object error,
    StackTrace stackTrace, {
    required String datasourceName,
    Map<String, String>? requestHeaders,
    Uri? requestUri,
    Object? requestBody,
  }) {
    isOnDriverException = isOnDriverException + 1;
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
    isOnInadmissibleException = isOnInadmissibleException + 1;
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
    isOnUnControlException = isOnUnControlException + 1;
  }

  @override
  void onUriCreation(
    String? url,
    Map<String, String> modifyParameters,
    Uri? uri, {
    required String datasourceName,
  }) {
    isOnUriCreation = isOnUriCreation + 1;
  }
}

base class CustomDatasourceObserver implements SimpleDatasourceObserver {
  int isOnCreateCall = 0;
  int isOnDisposeCall = 0;
  @override
  void onCreate(String name) {
    isOnCreateCall = isOnCreateCall + 1;
    log('on create');
  }

  @override
  void onDispose(String name) {
    isOnDisposeCall = isOnDisposeCall + 1;
    log('on dispose');
  }
}
