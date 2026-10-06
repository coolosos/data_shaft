part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HEAD** requests.
///
/// Use this mixin when you only need response metadata (headers) or want to
/// check a resource's availability without transferring its body.
mixin HeadCall<
  RemoteObject extends Codable<Object, RemoteObject>,
  Driver extends RemoteDriver<Object?>
>
    on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a HEAD request.
  ///
  /// Returns [HeadParams], which mirrors [GetParams] (no payload).
  @override
  HeadParams generateCallRequirement({required Params params});
}
