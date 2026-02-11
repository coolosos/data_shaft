import 'package:cool_bedrock/cool_bedrock.dart' show SimpleObserver;
import 'package:meta/meta.dart';

import '../observers/datasource/datasource_observer_instances.dart';

/// {@template data_shaft.datasource}
/// The fundamental abstract base class for all Data Source implementations.
///
/// A [DataSource] acts as a contract for retrieving and manipulating data
/// that is consumed directly by a Repository implementation.
///
/// This base class provides built-in lifecycle management, observer registration,
/// and necessary methods for proper disposal of resources.
/// {@endtemplate}
abstract class DataSource {
  /// {@macro data_shaft.datasource}
  DataSource() {
    datasourceObserver.onCreate(runtimeType.toString());
  }

  /// Retrieves the standard observer instance used to track the lifecycle
  /// and events of all Data Sources in the application.
  ///
  /// The observer is intended for internal tracking and should not be accessed directly by layers outside
  /// the Data implementation package.
  @protected
  SimpleObserver get datasourceObserver =>
      DatasourceObserverInstances.datasourceObserver;

  /// Called when the [DataSource] instance is no longer needed and should
  /// release any held resources (e.g., closing connections, unregistering listeners).
  ///
  /// Subclasses that override this method **must** call `super.dispose()`
  /// to ensure the observer is properly notified of the disposal.
  @mustCallSuper
  void dispose() {
    datasourceObserver.onDispose(runtimeType.toString());
  }
}
