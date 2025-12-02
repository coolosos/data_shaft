import '../datasources/datasource_callable.dart';
import 'helpers/deduplication_repository_helper.dart';
import 'safe_repository_datasource_callable.dart';

abstract class DeduplicationRepository<
  Info,
  DS extends DataSourceCallable<Info>
>
    extends SafeRepositoryDatasourceCallable<Info, DS>
    with DeduplicationManagement {
  DeduplicationRepository({required super.dataSource});
}
