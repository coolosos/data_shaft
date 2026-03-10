part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP PATCH** requests.
///
/// Use this mixin for partial updates to a resource. It ensures the request
/// follows the PATCH semantics.
mixin PatchCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a PATCH request.
  @override
  PatchParams generateCallRequirement({required Params params});
}
