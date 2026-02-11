part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP DELETE** requests.
///
/// Use this mixin for removing resources.
///
/// While DELETE requests typically do not contain a body, this implementation
/// supports passing a body via [DeleteParams] if the server API requires it.
mixin DeleteCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  @override
  Future<RemoteObject> call({required Params params}) async {
    final deleteParams = generateCallRequirement(params: params);

    final callUri = _obtainUriWithParams(deleteParams, uri);
    final body = deleteParams?.encodeBody?.call();

    observer.onCall(
      callUri,
      datasourceName: runtimeType.toString(),
      body: body?.toString(),
    );

    final response = await driver.delete(
      callUri,
      headers: deleteParams?.headers,
      body: body,
      encoding: deleteParams?.encoding,
      options: deleteParams?.driverOptions,
    );

    return checkInformation(
      requestResponse: response,
      requestHeaders: deleteParams?.headers,
      requestUri: callUri,
      // Pass the body to checkInformation for logging/debugging purposes,
      // even if the response usually doesn't return the sent body.
    );
  }

  /// Generates the specific parameters required for a DELETE request.
  @override
  DeleteParams? generateCallRequirement({required Params params});
}
