part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP PATCH** requests.
///
/// Use this mixin for partial updates to a resource. It ensures the request
/// follows the PATCH semantics.
mixin PatchCall<
  RemoteObject extends Codable<Object, RemoteObject>,
  Driver extends RemoteDriver
>
    on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a PATCH request.
  @override
  PatchParams? generateCallRequirement({required Params params});

  @override
  Future<RemoteObject> call({required Params params}) async {
    final patchParams = generateCallRequirement(params: params);

    final callUri = _obtainUriWithParams(patchParams, uri);
    final body = patchParams?.encodeBody?.call();

    observer.onCall(
      callUri,
      body: body?.toString(),
      datasourceName: runtimeType.toString(),
    );

    final response = await driver.patch(
      callUri,
      headers: patchParams?.headers,
      body: body,
      encoding: patchParams?.encoding,
      options: patchParams?.driverOptions,
    );

    return checkInformation(
      requestResponse: response,
      requestHeaders: patchParams?.headers,
      requestUri: callUri,
      requestBody: body,
    );
  }
}
