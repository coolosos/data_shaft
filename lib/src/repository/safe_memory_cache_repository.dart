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
/// 4. If the call is successful, update the cache via [refreshCache].
/// {@endtemplate}
abstract class SafeMemoryCacheRepository<Info,
        DS extends DataSourceCallable<Info>>
    extends SafeRepositoryDatasourceCallable<Info, DS>
    with MemoryCacheHelper<Info> {
  /// {@macro data_shaft.safe_memory_cache_repository}
  SafeMemoryCacheRepository({
    required super.dataSource,
    required this.refreshDuration,
  });

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

    // 3. Update Cache
    cache = refreshCache(datasourceResponse: data);
    return data;
  }

  /// Extracts the data from the response to update the cache.
  ///
  /// By default, it returns the data if the response is [Right], or null if [Left].
  /// Override this if you need custom logic for when to update the cache.
  Info? refreshCache({
    required Either<RepositoryError, Info> datasourceResponse,
  }) {
    return datasourceResponse.toNullable();
  }
}
