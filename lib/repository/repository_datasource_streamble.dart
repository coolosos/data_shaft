import 'dart:async';

import 'package:meta/meta.dart';

import '../../observers/repository/repository_observer_instances.dart';
import '../datasources/datasource_streamable.dart';
import 'repository_datasource.dart';

abstract class RepositoryDataSourceStreamable<
  ValueType,
  DS extends DataSourceStreamable<ValueType>
>
    extends RepositoryDataSource<DS> {
  RepositoryDataSourceStreamable({required super.dataSource});

  @protected
  RepositoryDataSourceStreamableObserver get observer =>
      RepositoryObserverInstances.repositoryDataSourceStreamableObserver;

  Stream<ValueType> stream({required covariant Params params}) {
    observer.start(runtimeType.toString(), dataSource.runtimeType.toString());
    return dataSource.stream(params: params);
  }
}
