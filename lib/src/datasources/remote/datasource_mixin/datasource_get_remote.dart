import 'package:cool_bedrock/cool_bedrock.dart' show Codable;

import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';

/// {@template data_shaft.datasource_get_remote}
/// A specialized [DatasourceRemote] for handling **HTTP GET** operations.
///
/// Use this class to fetch data from a remote server without side effects.
/// This is the most common class for read-only operations.
/// {@endtemplate}
abstract base class DatasourceGetRemote<
        RemoteObject extends Codable<Object, RemoteObject>,
        Driver extends RemoteDriver>
    extends DatasourceRemote<RemoteObject, Driver>
    with GetCall<RemoteObject, Driver> {
  /// {@macro data_shaft.datasource_get_remote}
  DatasourceGetRemote({required super.driver});
}
