part of 'request_mixin.dart';

/// A mixin that implements the [call] method for **HTTP POST** requests.
///
/// Use this mixin when the datasource is intended to create new resources on the server.
/// It handles the serialization of the body via [PostParams.encodeBody].
mixin PostCall<RemoteObject extends Codable<Object, RemoteObject>,
    Driver extends RemoteDriver> on DatasourceRemote<RemoteObject, Driver> {
  /// Generates the specific parameters required for a POST request.
  ///
  /// This should return [PostParams], including headers, the body encoding logic,
  /// and any driver-specific options.
  @override
  PostParams generateCallRequirement({required Params params});
}
