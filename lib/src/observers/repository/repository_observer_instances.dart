library;

import 'dart:developer';

import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:meta/meta.dart';

part 'repository_observer.dart';
part 'repository_observer_implementations.dart';

/// {@template data_shaft.repository_observer_instances}
/// Global registry for Repository layer observers.
///
/// Allows the injection of custom observers for logging, crash reporting,
/// or analytics. If no custom observer is provided, it defaults to
/// internal implementations that use `dart:developer`.
/// {@endtemplate}
class RepositoryObserverInstances {
  static RepositoryObserver? _repositoryObserver;
  static set repositoryObserver(RepositoryObserver observer) =>
      _repositoryObserver = observer;
  static RepositoryObserver get repositoryObserver =>
      _repositoryObserver ?? _DefaultRepositoryImp();

  static RepositoryDataSourceCallableObserver?
      _repositoryDatasourceCallableObserver;
  static set repositoryDatasourceCallableObserver(
    RepositoryDataSourceCallableObserver observer,
  ) =>
      _repositoryDatasourceCallableObserver = observer;
  static RepositoryDataSourceCallableObserver
      get repositoryDatasourceCallableObserver =>
          _repositoryDatasourceCallableObserver ?? _DefaultRepositoryImp();

  static RepositoryDataSourceStreamableObserver?
      _repositoryDataSourceStreamableObserver;
  static set repositoryDataSourceStreamableObserver(
    RepositoryDataSourceStreamableObserver observer,
  ) =>
      _repositoryDataSourceStreamableObserver = observer;
  static RepositoryDataSourceStreamableObserver
      get repositoryDataSourceStreamableObserver =>
          _repositoryDataSourceStreamableObserver ??
          _DefaultRepositoryDataSourceStreamableObserverImpl();

  static SafeCallableRepositoryObserver? _safeCallableObserver;
  static set safeCallableObserver(SafeCallableRepositoryObserver observer) =>
      _safeCallableObserver = observer;
  static SafeCallableRepositoryObserver get safeCallableObserver =>
      _safeCallableObserver ?? _DefaultSafeRepository();
}
