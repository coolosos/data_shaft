import '../datasources/datasource_callable.dart';
import 'helpers/deduplication_repository_helper.dart';
import 'safe_memory_cache_repository.dart';

abstract class DeduplicationCacheRepository<
  Info,
  DS extends DataSourceCallable<Info>
>
    extends SafeMemoryCacheRepository<Info, DS>
    with DeduplicationManagement {
  DeduplicationCacheRepository({
    required super.dataSource,
    required super.refreshDuration,
  });
}
