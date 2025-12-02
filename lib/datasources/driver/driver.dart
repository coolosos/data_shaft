/// {@template data_shaft.driver}
/// The fundamental abstraction for all **Data Drivers** within the Data Layer.
///
/// A [Driver] acts as a low-level utility to handle connectivity or data retrieval
/// logic before it is processed by a higher-level DataSource.
///
/// Drivers are typically categorized into two main types: Basic (local) and Remote (network).
///
/// This base class enforces a uniform type for utilities, ensuring a clean separation of concerns and testability.
/// {@endtemplate}
abstract base class Driver {
  /// {@macro data_shaft.driver}
  const Driver();
}
