part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP POST** requests.
///
/// Use this mixin when the datasource is intended to create new resources on the server.
/// It handles the serialization of the body via [PostParams.encodeBody].
mixin PostCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  @override
  Future<RemoteObject> call({required Params params}) async {
    final postParams = generateCallRequirement(params: params);

    final callUri = _obtainUriWithParams(postParams, uri);

    final body = postParams?.encodeBody?.call();

    observer.onCall(
      callUri,
      body: body?.toString(),
      datasourceName: runtimeType.toString(),
    );

    final response = await driver.post(
      callUri,
      headers: postParams?.headers,
      body: body,
      encoding: postParams?.encoding,
      options: postParams?.driverOptions,
    );

    return checkInformation(
      requestResponse: response,
      requestHeaders: postParams?.headers,
      requestUri: callUri,
      requestBody: body,
    );
  }

  /// Generates the specific parameters required for a POST request.
  ///
  /// This should return [PostParams], including headers, the body encoding logic,
  /// and any driver-specific options.
  @override
  PostParams? generateCallRequirement({required Params params});
}
