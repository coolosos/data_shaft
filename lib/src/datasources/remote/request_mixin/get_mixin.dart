part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **GET** requests.
///
/// Use this mixin for obtaining a resource. It ensures the request
/// follows the GET semantics.
mixin GetCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a GET request.
  ///
  /// Returns [GetParams], which typically excludes a body but includes query parameters
  /// and headers.
  @override
  GetParams generateCallRequirement({required Params params});
}
