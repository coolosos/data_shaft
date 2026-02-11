import 'package:cool_bedrock/cool_bedrock.dart' show Codable;

import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';

/// {@template data_shaft.datasource_put_remote}
/// A specialized [DatasourceRemote] for handling **HTTP PUT** operations.
///
/// Use this class when you need to replace an existing resource entirely on the server.
/// It utilizes the [PutCall] mixin to manage the request lifecycle.
/// {@endtemplate}
abstract base class DatasourcePutRemote<
        RemoteObject extends Codable<Object, RemoteObject>,
        Driver extends RemoteDriver>
    extends DatasourceRemote<RemoteObject, Driver>
    with PutCall<RemoteObject, Driver> {
  /// {@macro data_shaft.datasource_put_remote}
  DatasourcePutRemote({required super.driver});
}
