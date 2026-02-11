import '../datasources/datasource.dart';
import 'base_repository.dart';

/// {@template data_shaft.repository_data_source}
/// A specialized [Repository] that holds a reference to a [DataSource].
///
/// This class serves as the base for all repositories that need to interact
/// with a data layer (either remote or local). It ensures that the
/// [dataSource] is injected and available for its subclasses.
///
/// **Generic Types:**
/// * [DS]: The specific type of [DataSource] this repository will use.
///
/// ### Example:
/// ```dart
/// class MyRepository extends RepositoryDataSource<MyDataSource> {
///   MyRepository({required super.dataSource});
///
///   // Now you can access this.dataSource to perform operations.
/// }
/// ```
/// {@endtemplate}
abstract class RepositoryDataSource<DS extends DataSource> extends Repository {
  /// Creates a [RepositoryDataSource] with the provided [dataSource].
  RepositoryDataSource({required this.dataSource});

  /// The [DataSource] instance used by this repository to fetch or persist data.
  final DS dataSource;
}
