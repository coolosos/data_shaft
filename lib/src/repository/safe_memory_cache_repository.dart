import 'package:cool_bedrock/cool_bedrock.dart';

import '../datasources/datasource_callable.dart';
import 'helpers/memory_repository_helper.dart';
import 'safe_repository_datasource_callable.dart';

/// {@template data_shaft.safe_memory_cache_repository}
/// A [SafeRepositoryDatasourceCallable] that implements an in-memory caching strategy.
///
/// It checks for valid cached data before making a network request.
///
/// **Strategy:**
/// 1. Check if [isRefreshRequired] returns `false`.
/// 2. If valid cache exists, return [Right] with cached data immediately.
/// 3. If cache is expired or missing, call the datasource.
/// 4. Update the cache via [refreshCache] (invoked on every outcome).
/// {@endtemplate}
abstract class SafeMemoryCacheRepository<
  Info,
  DS extends DataSourceCallable<Info>
>
    extends SafeRepositoryDatasourceCallable<Info, DS>
    with MemoryCacheHelper<Info> {
  /// {@macro data_shaft.safe_memory_cache_repository}
  new({required super.dataSource, required this.refreshDuration});

  @override
  final Duration refreshDuration;

  @override
  Future<Either<RepositoryError, Info>> call({
    required covariant Params repositoryParams,
  }) async {
    // 1. Try Cache
    if (!isRefreshRequired()) {
      final cachedData = cache;
      if (cachedData != null) {
        return Right(cachedData);
      }
    }

    // 2. Call Remote (Safe execution)
    final data = await super.call(repositoryParams: repositoryParams);

    // 3. Update Cache through the extensible [refreshCache] hook. It is
    //    invoked on every outcome so overrides can implement custom policies
    //    (keep the last cache on failure, cooldown, stale-while-failing, ...).
    //    A `null` result clears the cache (default behavior on failure).
    cache = refreshCache(datasourceResponse: data);

    return data;
  }

  /// Extracts the data from the response to update the cache.
  ///
  /// Invoked after every call (success and failure). Assigns its result to
  /// the [cache]; a `null` result clears the cache and a non-null result
  /// refreshes its timestamp.
  ///
  /// By default it returns the payload of a [Right] response and `null` for
  /// a [Left] response, so failed calls clear the cache.
  ///
  /// Override this if you need custom logic for when to update the cache,
  /// e.g. keep the last valid value on failure:
  /// `return datasourceResponse.toNullable() ?? cache;`
  Info? refreshCache({
    required Either<RepositoryError, Info> datasourceResponse,
  }) {
    return datasourceResponse.toNullable();
  }
}
