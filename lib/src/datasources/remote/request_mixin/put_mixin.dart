part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP PUT** requests.
///
/// Use this mixin when the datasource is intended to replace an existing resource completely.
mixin PutCall<
  RemoteObject extends Codable<Object, RemoteObject>,
  Driver extends RemoteDriver
>
    on DatasourceRemote<RemoteObject, Driver> {
  @override
  Future<RemoteObject> call({required Params params}) async {
    final putParams = generateCallRequirement(params: params);

    final callUri = _obtainUriWithParams(putParams, uri);
    final body = putParams?.encodeBody?.call();

    observer.onCall(
      callUri,
      datasourceName: runtimeType.toString(),
      body: body.toString(),
    );

    final response = await driver.put(
      callUri,
      headers: putParams?.headers,
      body: body,
      encoding: putParams?.encoding,
      options: putParams?.driverOptions,
    );

    return checkInformation(
      requestResponse: response,
      requestHeaders: putParams?.headers,
      requestUri: callUri,
      requestBody: body,
    );
  }

  /// Generates the specific parameters required for a PUT request.
  ///
  /// Returns [PutParams], typically requiring a body payload to replace the resource.
  @override
  PutParams? generateCallRequirement({required Params params});
}
