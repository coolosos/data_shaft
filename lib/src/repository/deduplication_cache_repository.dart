import '../datasources/datasource_callable.dart';
import 'helpers/deduplication_repository_helper.dart';
import 'safe_memory_cache_repository.dart';

/// {@template data_shaft.deduplication_cache_repository}
/// The most complete [Repository] implementation, combining safety,
/// memory caching, and request deduplication.
///
/// This class is designed for high-performance data fetching where you want to
/// minimize network overhead and ensure consistent data across the app.
///
/// **The Execution Flow:**
/// 1. **Cache Check**: If valid data exists in memory ([isRefreshRequired] is false), it returns immediately.
/// 2. **Deduplication**: If no cache exists but an identical request is already in progress, it waits for that request.
/// 3. **Execution**: If it's a new unique request, it calls the [DataSource].
/// 4. **Safety**: Any exception during the process is caught and mapped to a [RepositoryError].
/// 5. **Update**: Successful results are stored in the cache for future calls.
///
/// **Generic Types:**
/// * [Info]: The data model type.
/// * [DS]: The [DataSourceCallable] used to fetch the data.
/// {@endtemplate}
abstract class DeduplicationCacheRepository<Info,
        DS extends DataSourceCallable<Info>>
    extends SafeMemoryCacheRepository<Info, DS> with DeduplicationManagement {
  /// Creates a [DeduplicationCacheRepository].
  ///
  /// Requires a [dataSource] and a [refreshDuration] to determine
  /// how long the cache remains valid.
  DeduplicationCacheRepository({
    required super.dataSource,
    required super.refreshDuration,
  });
}
