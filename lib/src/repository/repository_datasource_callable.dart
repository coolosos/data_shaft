import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart'
    show Either, RepositoryError, Right;

import '../datasources/datasource_callable.dart';
import '../observers/repository/repository_observer_instances.dart';
import 'repository_datasource.dart';

/// {@template data_shaft.repository_datasource_callable}
/// A Repository implementation that wraps a specific [DataSourceCallable].
///
/// This class handles the direct execution of the datasource and logs the
/// lifecycle events (before/after call) via [RepositoryDataSourceCallableObserver].
///
/// **Note:** This class does NOT handle exceptions automatically.
/// For automatic error handling, use [SafeRepositoryDatasourceCallable].
/// {@endtemplate}
abstract class RepositoryDataSourceCallable<ValueType,
    DS extends DataSourceCallable<ValueType>> extends RepositoryDataSource<DS> {
  /// {@macro data_shaft.repository_datasource_callable}
  RepositoryDataSourceCallable({required super.dataSource});

  RepositoryDataSourceCallableObserver get observer =>
      RepositoryObserverInstances.repositoryDatasourceCallableObserver;

  /// Executes the datasource with the given [repositoryParams].
  ///
  /// It wraps the result in a [Right], assuming success.
  FutureOr<Either<RepositoryError, ValueType>> call({
    required covariant Params repositoryParams,
  }) async {
    final startTime = DateTime.now();

    observer.beforeCall(
      runtimeType.toString(),
      dataSource.runtimeType.toString(),
      startTime: startTime,
    );

    final data = await dataSource.call(params: repositoryParams);

    final endTime = DateTime.now();
    final elapsed = endTime.difference(startTime);

    observer.afterCall(
      runtimeType.toString(),
      dataSource.runtimeType.toString(),
      data,
      endTime: endTime,
      elapsed: elapsed,
    );
    return Right(data);
  }
}
