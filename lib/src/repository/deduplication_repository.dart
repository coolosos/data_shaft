import '../datasources/datasource_callable.dart';
import 'helpers/deduplication_repository_helper.dart';
import 'safe_repository_datasource_callable.dart';

/// {@template data_shaft.deduplication_repository}
/// A [SafeRepositoryDatasourceCallable] enhanced with request deduplication logic.
///
/// This repository is ideal for preventing redundant network calls when multiple
/// parts of the application request the same data at the same time.
///
/// **How it works:**
/// If a call is already in progress for a specific set of [Params], any
/// subsequent calls with the same [Params] will wait for the first call's
/// result instead of triggering a new request.
///
/// ### Example Scenario:
/// Imagine two different UI Widgets call `getUser(id: '1')` at the exact
/// same millisecond.
/// 1. The first call triggers the `DataSource`.
/// 2. The second call "hooks" into the first one.
/// 3. Both widgets receive the same `User` object simultaneously when the
///    network request finishes.
///
/// Inherits all safety features from [SafeRepositoryDatasourceCallable].
/// {@endtemplate}
abstract class DeduplicationRepository<Info,
        DS extends DataSourceCallable<Info>>
    extends SafeRepositoryDatasourceCallable<Info, DS>
    with DeduplicationManagement {
  /// Creates a [DeduplicationRepository] with the provided [dataSource].
  DeduplicationRepository({required super.dataSource});
}
