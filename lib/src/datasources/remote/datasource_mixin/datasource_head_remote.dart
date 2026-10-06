import 'package:cool_bedrock/cool_bedrock.dart' show Codable;

import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';

/// {@template data_shaft.datasource_head_remote}
/// A specialized [DatasourceRemote] for handling **HTTP HEAD** operations.
///
/// Use this class to retrieve response metadata (headers) without the body,
/// e.g. for resource existence checks or cache validation.
/// {@endtemplate}
abstract base class DatasourceHeadRemote<
  RemoteObject extends Codable<Object, RemoteObject>,
  Driver extends RemoteDriver<Object?>
>
    extends DatasourceRemote<RemoteObject, Driver>
    with HeadCall<RemoteObject, Driver> {
  /// {@macro data_shaft.datasource_head_remote}
  new({required super.driver});
}
