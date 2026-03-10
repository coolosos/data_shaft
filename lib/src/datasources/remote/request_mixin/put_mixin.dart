part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP PUT** requests.
///
/// Use this mixin when the datasource is intended to replace an existing resource completely.
mixin PutCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a PUT request.
  ///
  /// Returns [PutParams], typically requiring a body payload to replace the resource.
  @override
  PutParams generateCallRequirement({required Params params});
}
