import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/src/datasources/datasource_callable.dart';
import 'package:data_shaft/src/datasources/remote/request_response/request_response.dart';
import 'package:data_shaft/src/issues/datasource_exception/inadmissible_data_source_exception.dart';
import 'package:data_shaft/src/issues/datasource_exception/un_control_data_source_exception.dart';
import 'package:data_shaft/src/observers/datasource/datasource_observer_instances.dart'
    show DatasourceObserverInstances, HttpDatasourceObserver;
import 'package:meta/meta.dart';

import '../driver/remote_driver.dart';
import 'request_params/request_params.dart';

export 'datasource_mixin/datasource_mixin.dart';
export 'request_mixin/request_mixin.dart';
export 'request_params/request_params.dart';
export 'request_response/request_response.dart';

/// {@template data_shaft.datasource_remote}
/// An abstract [DataSourceCallable] designed to manage data interactions with a
/// **remote service** (e.g., REST API, WebSocket, external database).
///
/// This class ensures that all remote data sources have access to a
/// properly configured [RemoteDriver], which handles the low-level concerns
/// of connectivity and client management (e.g., HTTP client, connection pool).
///
/// Implementations of this class will define the method `null` for specific remote
/// data operation (e.g., `fetchUser`, `sendOrder`) and rely on the injected
/// [driver] to execute the actual network requests.
///
/// - [Driver]: Must be a concrete implementation of [RemoteDriver]
///   (e.g., an HTTP client wrapper).
/// {@endtemplate}
abstract class DatasourceRemote<
    RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> extends DataSourceCallable<RemoteObject> {
  /// {@macro data_shaft.datasource_remote}
  ///
  /// The [driver] is a required dependency that facilitates all network
  /// or remote communication logic.
  DatasourceRemote({required this.driver});

  ///host of the provide information, can contains port and scheme
  String get host;

  ///path of the provide information
  String? get path;
  String? get pathPrefix => '';

  ///path of the provide information
  Map<String, String> get pathModification => {};

  ///List of http status code with the admissible status codes.
  List<int> get admissibleStatusCode;

  ///List of http status code with the inadmissible status codes.
  ///
  ///When inadmissible statusCode is return in call a [InadmissibleDataSourceException] with the current information.
  ///
  ///Usually this must be uses for datasource error status code control.
  List<int> get inadmissibleStatusCode => [];

  @override
  HttpDatasourceObserver get observer =>
      DatasourceObserverInstances.httpDatasourceObserver;

  /// The underlying [RemoteDriver] instance used to execute remote operations.
  ///
  /// This driver is responsible for managing the connection lifecycle and
  /// executing the low-level transport protocol.
  final Driver driver;

  String _buildPath() {
    final prefix = pathPrefix ?? '';
    final currentPath = path ?? '';

    if (prefix.isEmpty) {
      return currentPath;
    }
    if (currentPath.isEmpty) {
      return prefix;
    }

    final prefixEndsWithSlash = prefix.endsWith('/');
    final pathStartsWithSlash = currentPath.startsWith('/');

    if (prefixEndsWithSlash && pathStartsWithSlash) {
      return prefix + currentPath.substring(1);
    } else if (!prefixEndsWithSlash && !pathStartsWithSlash) {
      return '$prefix/$currentPath';
    } else {
      return prefix + currentPath;
    }
  }

  ///Current url transformation to URI.
  ///
  ///In tryParse failures [FormatException] will be throw.
  Uri get uri {
    final uri = Uri.parse(host); //!will be throw.
    final checkPath = uri.path.replaceFirst('/', '');

    if (uri.host.isEmpty || checkPath.isNotEmpty) {
      throw const FormatException('Url provide is not a valid URL');
    }

    var modifyPath = _buildPath();
    pathModification.forEach(
      (key, value) => modifyPath = modifyPath.replaceFirst(key, value),
    );

    final completeUri = Uri(
      host: uri.host,
      port: uri.port,
      path: modifyPath,
      scheme: uri.scheme,
    );

    observer.onUriCreation(
      path,
      pathModification,
      completeUri,
      datasourceName: runtimeType.toString(),
    );

    return completeUri;
  }

  ///Function call after response success.
  ///
  ///Transform the information of response.body in [RemoteObject] object.
  ///This function is required because factory of T is not possible.
  FutureOr<RemoteObject> transformation({
    required RequestResponse remoteResponse,
  });

  ///Usually use after server call to return the required data or failure.
  ///
  ///By default, [transformation] function will be call after success response.
  @mustCallSuper
  FutureOr<RemoteObject> checkInformation({
    required RequestResponse requestResponse,
    required Map<String, String>? requestHeaders,
    required Uri? requestUri,
    Object? requestBody,
  }) {
    if (inadmissibleStatusCode.contains(requestResponse.statusCode)) {
      observer.onInadmissibleException(
        requestResponse.statusCode,
        requestResponse.body ?? '',
        requestResponse.originalResponse,
        List.from(inadmissibleStatusCode),
        datasourceName: runtimeType.toString(),
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        requestUri: requestUri,
      );

      throw InadmissibleDataSourceException(
        statusCode: requestResponse.statusCode,
        body: requestResponse.body ?? '',
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        requestUri: requestUri,
      );
    }
    if (!admissibleStatusCode.contains(requestResponse.statusCode)) {
      observer.onUnControlException(
        requestResponse.statusCode,
        requestResponse.body ?? '',
        requestResponse.originalResponse,
        List.from(inadmissibleStatusCode),
        List.from(admissibleStatusCode),
        datasourceName: runtimeType.toString(),
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        requestUri: requestUri,
      );

      throw UnControlDataSourceException(
        statusCode: requestResponse.statusCode,
        body: 'Unexpect error. No admissible values provide by server.\n',
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        requestUri: requestUri,
      );
    }

    final objectResult = transformation(remoteResponse: requestResponse);

    observer.onAdmissible(objectResult, datasourceName: runtimeType.toString());

    return objectResult;
  }

  ///Generate a request params from repository or usecase params
  RequestParams generateCallRequirement({required covariant Params params});

  /// Centralized method to handle all HTTP requests.
  @protected
  Future<RemoteObject> request(RequestParams requestParams) async {
    final callUri = requestParams.modifyUriWithUrlParams(uri);

    final body = requestParams.encodeBody?.call();

    observer.onCall(
      callUri,
      body: body?.toString(),
      datasourceName: runtimeType.toString(),
    );

    final RequestResponse response;
    try {
      response = await switch (requestParams) {
        DeleteParams() => driver.delete(
            callUri,
            headers: requestParams.headers,
            body: body,
          ),
        PutParams() => driver.put(
            callUri,
            headers: requestParams.headers,
            body: body,
          ),
        GetParams() => driver.get(callUri, headers: requestParams.headers),
        PatchParams() => driver.patch(
            callUri,
            headers: requestParams.headers,
            body: body,
          ),
        PostParams() => driver.post(
            callUri,
            headers: requestParams.headers,
            body: body,
          ),
      };
    } catch (error, stackTrace) {
      observer.onDriverException(
        error,
        stackTrace,
        datasourceName: runtimeType.toString(),
        requestBody: body?.toString(),
        requestUri: callUri,
        requestHeaders: requestParams.headers,
      );
      rethrow;
    }
    return checkInformation(
      requestResponse: response,
      requestHeaders: requestParams.headers,
      requestUri: callUri,
      requestBody: body,
    );
  }

  ///Manage the server connection.
  ///
  ///Usually use with [checkInformation] function for control server answer.
  // Future<Info> call({required covariant Params params});
  @override
  Future<RemoteObject> call({required covariant Params params}) {
    return request(generateCallRequirement(params: params));
  }
}
