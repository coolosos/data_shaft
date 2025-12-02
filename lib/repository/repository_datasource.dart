import '../datasources/datasource.dart';
import 'base_repository.dart';

abstract class RepositoryDataSource<DS extends DataSource> extends Repository {
  RepositoryDataSource({required this.dataSource});

  final DS dataSource;
}
