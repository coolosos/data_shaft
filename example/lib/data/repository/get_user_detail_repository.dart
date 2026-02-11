import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/repository.dart';
import 'package:data_shaft_example/data/datasource/get_user_detail_datasource.dart';

final class GetUserDetailRepository
    extends DeduplicationRepository<RemoteUser, GetUserDetailDatasource> {
  GetUserDetailRepository({required super.dataSource});

  @override
  Future<Either<RepositoryError, RemoteUser>> call({
    required NoParams repositoryParams,
  });
}
