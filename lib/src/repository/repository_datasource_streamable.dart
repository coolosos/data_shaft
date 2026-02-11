import 'dart:async';

import 'package:meta/meta.dart';

import '../datasources/datasource_streamable.dart';
import '../observers/repository/repository_observer_instances.dart';
import 'repository_datasource.dart';

/// {@template data_shaft.repository_data_source_streamable}
/// A specialized [Repository] that manages a [Stream] of data from a [DataSourceStreamable].
///
/// Unlike "Callable" repositories that handle a single request/response cycle,
/// this repository establishes a continuous data flow. It is ideal for
/// reactive features like real-time updates, chat applications, or
/// database listeners.
///
/// **Generic Types:**
/// * [ValueType]: The type of data emitted by the stream.
/// * [DS]: A [DataSourceStreamable] that provides the actual stream.
/// {@endtemplate}
abstract class RepositoryDataSourceStreamable<ValueType,
        DS extends DataSourceStreamable<ValueType>>
    extends RepositoryDataSource<DS> {
  /// Creates a [RepositoryDataSourceStreamable] with the provided [dataSource].
  RepositoryDataSourceStreamable({required super.dataSource});

  /// The observer responsible for monitoring stream lifecycle events
  /// (start, data, error, etc.).
  @protected
  RepositoryDataSourceStreamableObserver get observer =>
      RepositoryObserverInstances.repositoryDataSourceStreamableObserver;

  /// Returns a [Stream] provided by the [dataSource].
  ///
  /// Before returning the stream, it notifies the [observer] that the
  /// connection/subscription is starting.
  ///
  /// **Parameters:**
  /// * [params]: The parameters required by the datasource to establish the stream.
  Stream<ValueType> stream({required covariant Params params}) {
    observer.start(runtimeType.toString(), dataSource.runtimeType.toString());
    return dataSource.stream(params: params);
  }
}
