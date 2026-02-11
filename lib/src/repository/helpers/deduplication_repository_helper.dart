import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart' show Either, RepositoryError;

import '../../datasources/datasource_callable.dart';
import '../repository_datasource_callable.dart';

/// {@template data_shaft.deduplication_management}
/// Prevents redundant, simultaneous calls to the same endpoint with the same parameters.
///
/// If [call] is invoked while another identical call (same [Params]) is in flight,
/// it returns the existing [Future] instead of starting a new request.
///
/// **Note:** Ensure your [Params] implementation overrides `==` and `hashCode`
/// for the deduplication key to work correctly.
/// {@endtemplate}
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

    final newCompleter = Completer<T>();
    _deduplication = newCompleter;

    try {
      final response = await deduplicationFunction();
      newCompleter.complete(response);
      return response;
    } catch (e) {
      newCompleter.completeError(e);
      rethrow;
    } finally {
      _deduplication = null;
    }
  }
}
