import 'package:cool_bedrock/cool_bedrock.dart' show Codable;

import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';

/// {@template data_shaft.datasource_delete_remote}
/// A specialized [DatasourceRemote] for handling **HTTP DELETE** operations.
///
/// Use this class to remove resources from a remote server.
/// It integrates the [DeleteCall] logic.
/// {@endtemplate}
abstract base class DatasourceDeleteRemote<
        RemoteObject extends Codable<Object, RemoteObject>,
        Driver extends RemoteDriver>
    extends DatasourceRemote<RemoteObject, Driver>
    with DeleteCall<RemoteObject, Driver> {
  /// {@macro data_shaft.datasource_delete_remote}
  DatasourceDeleteRemote({required super.driver});
}
