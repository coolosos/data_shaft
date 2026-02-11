part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **GET** requests.
///
/// Use this mixin for obtaining a resource. It ensures the request
/// follows the GET semantics.
mixin GetCall<
  RemoteObject extends Codable<Object, RemoteObject>,
  Driver extends RemoteDriver
>
    on DatasourceRemote<RemoteObject, Driver> {
  @override
  Future<RemoteObject> call({required Params params}) async {
    final requestParams = generateCallRequirement(params: params);

    final callUri = _obtainUriWithParams(requestParams, uri);

    observer.onCall(callUri, datasourceName: runtimeType.toString());

    final response = await driver.get(
      callUri,
      headers: requestParams?.headers,
      options: requestParams?.driverOptions,
    );

    return checkInformation(
      requestResponse: response,
      requestHeaders: requestParams?.headers,
      requestUri: callUri,
    );
  }

  /// Generates the specific parameters required for a GET request.
  ///
  /// Returns [GetParams], which typically excludes a body but includes query parameters
  /// and headers.
  @override
  GetParams? generateCallRequirement({required Params params});
}
