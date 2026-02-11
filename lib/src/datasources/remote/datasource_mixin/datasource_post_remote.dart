import 'package:cool_bedrock/cool_bedrock.dart' show Codable;

import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';

/// {@template data_shaft.datasource_post_remote}
/// A specialized [DatasourceRemote] for handling **HTTP POST** operations.
///
/// Use this class when you need to create new resources on a remote server.
/// It automatically integrates the [PostCall] logic, requiring you to
/// implement [generateCallRequirement] to provide [PostParams].
///
/// Example:
/// ```dart
/// class CreateUserDatasource extends DatasourcePostRemote<User, MyDriver> {
///   CreateUserDatasource({required super.driver});
///
///   @override
///   PostParams? generateCallRequirement({required UserParams params}) {
///     return PostParams(encodeBody: () => json.encode(params.toJson()));
///   }
/// }
/// ```
/// {@endtemplate}
abstract base class DatasourcePostRemote<
        RemoteObject extends Codable<Object, RemoteObject>,
        Driver extends RemoteDriver>
    extends DatasourceRemote<RemoteObject, Driver>
    with PostCall<RemoteObject, Driver> {
  /// {@macro data_shaft.datasource_post_remote}
  DatasourcePostRemote({required super.driver});
}
