part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP DELETE** requests.
///
/// Use this mixin for removing resources.
///
/// While DELETE requests typically do not contain a body, this implementation
/// supports passing a body via [DeleteParams] if the server API requires it.
mixin DeleteCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a DELETE request.
  @override
  DeleteParams generateCallRequirement({required Params params});
}
