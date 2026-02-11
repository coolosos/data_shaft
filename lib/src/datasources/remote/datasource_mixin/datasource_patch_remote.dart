import 'package:cool_bedrock/cool_bedrock.dart' show Codable;

import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';

/// {@template data_shaft.datasource_patch_remote}
/// A specialized [DatasourceRemote] for handling **HTTP PATCH** operations.
///
/// Use this class for partial updates to a remote resource.
/// It leverages the [PatchCall] mixin, requiring [PatchParams] to be generated.
/// {@endtemplate}
abstract base class DatasourcePatchRemote<
        RemoteObject extends Codable<Object, RemoteObject>,
        Driver extends RemoteDriver>
    extends DatasourceRemote<RemoteObject, Driver>
    with PatchCall<RemoteObject, Driver> {
  /// {@macro data_shaft.datasource_patch_remote}
  DatasourcePatchRemote({required super.driver});
}
