import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError, Either;

import '../../datasources/datasource_callable.dart';
import '../repository_datasource_callable.dart';

/// A mixin that provides deduplication logic for repository calls,
/// ensuring that only one execution is triggered per unique [Params].
///
/// If a call with the same parameters is already in progress,
/// it returns the same [Future] instead of initiating a new one.
///
/// This avoids redundant executions and saves resources by reusing
/// the result of the ongoing operation.
mixin DeduplicationManagement<Info, DS extends DataSourceCallable<Info>>
    on RepositoryDataSourceCallable<Info, DS> {
  /// Internal map that keeps track of in-flight operations.
  /// The key is the [Params] of the request, and the value is a [Completer]
  /// that will complete when the data source call finishes.
  final Map<Params, Completer<Either<RepositoryError, Info>>> _deduplication =
      {};

  /// Overrides the repository call to apply deduplication.
  ///
  /// - If a call with the same [usecaseParams] is already in progress,
  ///   returns the existing [Future].
  /// - Otherwise, initiates a new data source call, stores the [Completer],
  ///   and completes it once the operation finishes.
  @override
  Future<Either<RepositoryError, Info>> call({
    required covariant Params repositoryParams,
  }) async {
    final completer = _deduplication[repositoryParams];
    if (completer != null) {
      return completer.future;
    }
    _deduplication[repositoryParams] = Completer();

    final datasourceResponse = await super.call(
      repositoryParams: repositoryParams,
    );

    _deduplication[repositoryParams]?.complete(datasourceResponse);
    _deduplication.remove(repositoryParams);

    return datasourceResponse;
  }
}

/// A mixin that prevents concurrent execution of the same asynchronous operation.
///
/// It ensures that if multiple calls to [deduplicationExecution] happen while
/// a previous one is still in progress, they will all await the same result,
/// avoiding duplicated effort (e.g., repeated API calls).
///
/// Usage:
/// ```dart
/// final result = await deduplicationFunction(() async => await fetchData());
/// ```
///
/// This mixin stores a single internal [Completer], so it assumes only one
/// deduplicated call is active at a time. If multiple different operations
/// need deduplication simultaneously, consider using a keyed deduplication
/// strategy. Show [DeduplicationManagement] for more information about keyed
/// deduplication strategy.
mixin class DeduplicationExecution<T> {
  /// Internal completer used to manage the in-flight operation.
  Completer<T>? _deduplication;

  /// Executes [deduplicationFunction] only if no identical call is already running.
  ///
  /// If an operation is already in progress, this returns the same Future
  /// as the ongoing one. Otherwise, it starts a new execution and stores
  /// the result for others to await.
  ///
  /// Returns the result of the deduplicated asynchronous operation.
  Future<T> deduplicationExecution(
    Future<T> Function() deduplicationFunction,
  ) async {
    if (_deduplication case final completer?) {
      return completer.future;
    }

    _deduplication = Completer<T>();
    final deduplicationResponse = await deduplicationFunction();
    _deduplication?.complete(deduplicationResponse);
    _deduplication = null;
    return deduplicationResponse;
  }
}
