import 'driver.dart';

/// {@template data_shaft.remote_driver}
/// An abstract base class for [Driver] implementations designed to handle
/// **remote connectivity** and communication.
///
/// This driver is typically used for managing connections to external services
/// like REST APIs, WebSocket servers, or databases. It provides the necessary
/// contracts for establishing and terminating the connection lifecycle.
///
/// Implementations of this class should manage the underlying network client
/// or connection object (e.g., Dio client, WebSocket instance).
/// {@endtemplate}
abstract base class RemoteDriver extends Driver {
  /// {@macro data_shaft.remote_driver}
  const RemoteDriver();

  /// Attempts to establish the remote connection or prepare the underlying
  /// client for immediate use.
  ///
  /// This method must be called before attempting any data operations
  /// if the connection is not established lazily.
  Future<void> connect();

  /// Attempts to gracefully close the remote connection and dispose of
  /// any resources held by the driver.
  ///
  /// Returns `true` if the connection was successfully closed or was already closed,
  /// or `false` if the closing process failed.
  Future<bool> close();
}
