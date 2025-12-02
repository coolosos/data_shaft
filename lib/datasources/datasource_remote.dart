import 'datasource.dart';
import 'driver/remote_driver.dart';

/// {@template data_shaft.datasource_remote}
/// An abstract [DataSource] designed to manage data interactions with a
/// **remote service** (e.g., REST API, WebSocket, external database).
///
/// This class ensures that all remote data sources have access to a
/// properly configured [RemoteDriver], which handles the low-level concerns
/// of connectivity and client management (e.g., HTTP client, connection pool).
///
/// Implementations of this class will define the method `null` for specific remote
/// data operation (e.g., `fetchUser`, `sendOrder`) and rely on the injected
/// [driver] to execute the actual network requests.
///
/// - [Driver]: Must be a concrete implementation of [RemoteDriver]
///   (e.g., an HTTP client wrapper).
/// {@endtemplate}
abstract class DatasourceRemote<Driver extends RemoteDriver>
    extends DataSource {
  /// {@macro data_shaft.datasource_remote}
  ///
  /// The [driver] is a required dependency that facilitates all network
  /// or remote communication logic.
  DatasourceRemote({required this.driver});

  /// The underlying [RemoteDriver] instance used to execute remote operations.
  ///
  /// This driver is responsible for managing the connection lifecycle and
  /// executing the low-level transport protocol.
  final Driver driver;
}
