import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart'
    show RepositoryError, Either, Right;

import '../../observers/repository/repository_observer_instances.dart';
import '../datasources/datasource_callable.dart';
import 'repository_datasource.dart';

abstract class RepositoryDataSourceCallable<
  ValueType,
  DS extends DataSourceCallable<ValueType>
>
    extends RepositoryDataSource<DS> {
  RepositoryDataSourceCallable({required super.dataSource});

  RepositoryDataSourceCallableObserver get observer =>
      RepositoryObserverInstances.repositoryDatasourceCallableObserver;

  FutureOr<Either<RepositoryError, ValueType>> call({
    required covariant Params repositoryParams,
  }) async {
    observer.beforeCall(
      runtimeType.toString(),
      dataSource.runtimeType.toString(),
    );

    final data = await dataSource.call(params: repositoryParams);

    observer.afterCall(
      runtimeType.toString(),
      dataSource.runtimeType.toString(),
      data,
    );
    return Right(data);
  }
}
