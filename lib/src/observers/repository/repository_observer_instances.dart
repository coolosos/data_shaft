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
///
/// If you only set a higher-level observer (e.g. [safeCallableObserver]) and want
/// it to also serve as the fallback for less specific observer slots, enable
/// [useHigherObserver]:
///
/// ```dart
/// RepositoryObserverInstances.safeCallableObserver = MyCrashReporter();
/// RepositoryObserverInstances.useHigherObserver = true;
/// // repositoryObserver and repositoryDatasourceCallableObserver
/// // will also resolve to MyCrashReporter.
/// ```
/// {@endtemplate}
class RepositoryObserverInstances {
  static RepositoryObserver? _repositoryObserver;
  static RepositoryDataSourceCallableObserver?
      _repositoryDatasourceCallableObserver;
  static RepositoryDataSourceStreamableObserver?
      _repositoryDataSourceStreamableObserver;
  static SafeCallableRepositoryObserver? _safeCallableObserver;

  /// When enabled, if no explicit observer is set at a given level,
  /// the next more specific observer is used as fallback.
  /// Example: if only [safeCallableObserver] is set, it will also
  /// serve as [repositoryDatasourceCallableObserver] and [repositoryObserver].
  static bool useHigherObserver = false;

  /// Sets a custom observer for basic Repository lifecycle events ([onCreate], [onDispose]).
  static set repositoryObserver(RepositoryObserver observer) =>
      _repositoryObserver = observer;

  /// Returns the current repository lifecycle observer, or a default log implementation.
  ///
  /// If [useHigherObserver] is enabled and no explicit observer is set,
  /// falls back to [repositoryDatasourceCallableObserver], then [safeCallableObserver].
  static RepositoryObserver get repositoryObserver =>
      _repositoryObserver ??
      (useHigherObserver ? _repositoryDatasourceCallableObserver : null) ??
      (useHigherObserver ? _safeCallableObserver : null) ??
      _DefaultRepositoryImp();

  /// Sets a custom observer for one-shot repository calls (before/after DataSource).
  static set repositoryDatasourceCallableObserver(
    RepositoryDataSourceCallableObserver observer,
  ) =>
      _repositoryDatasourceCallableObserver = observer;

  /// Returns the current callable observer, or a default log implementation.
  ///
  /// If [useHigherObserver] is enabled and no explicit observer is set,
  /// falls back to [safeCallableObserver].
  static RepositoryDataSourceCallableObserver
      get repositoryDatasourceCallableObserver =>
          _repositoryDatasourceCallableObserver ??
          (useHigherObserver ? _safeCallableObserver : null) ??
          _DefaultRepositoryImp();

  /// Sets a custom observer for stream-based repositories.
  static set repositoryDataSourceStreamableObserver(
    RepositoryDataSourceStreamableObserver observer,
  ) =>
      _repositoryDataSourceStreamableObserver = observer;

  /// Returns the current streamable observer, or a default log implementation.
  static RepositoryDataSourceStreamableObserver
      get repositoryDataSourceStreamableObserver =>
          _repositoryDataSourceStreamableObserver ??
          _DefaultRepositoryDataSourceStreamableObserverImpl();

  /// Sets a custom observer that captures exceptions during safe calls.
  static set safeCallableObserver(SafeCallableRepositoryObserver observer) =>
      _safeCallableObserver = observer;

  /// Returns the current safe callable observer, or a default log implementation.
  static SafeCallableRepositoryObserver get safeCallableObserver =>
      _safeCallableObserver ?? _DefaultSafeRepository();

  /// Resets all observers and flags to their default state.
  /// Useful for testing isolation.
  static void reset() {
    _repositoryObserver = null;
    _repositoryDatasourceCallableObserver = null;
    _repositoryDataSourceStreamableObserver = null;
    _safeCallableObserver = null;
    useHigherObserver = false;
  }
}
