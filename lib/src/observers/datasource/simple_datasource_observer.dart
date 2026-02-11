part of 'datasource_observer_instances.dart';

/// {@template data_shaft.simple_datasource_observer}
/// Interface for monitoring the basic lifecycle of any [DataSource].
///
/// It tracks when a data source is initialized in memory and when it is
/// disposed, helping to detect memory leaks or unexpected recreations.
/// {@endtemplate}
abstract interface class SimpleDatasourceObserver implements SimpleObserver {
  @override
  void onCreate(String name);

  @override
  void onDispose(String name);
}
