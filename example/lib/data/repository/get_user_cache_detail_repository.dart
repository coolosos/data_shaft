import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/repository.dart';
import 'package:data_shaft_example/data/datasource/get_user_detail_datasource.dart';

final class GetUserCacheDetailRepository
    extends DeduplicationCacheRepository<RemoteUser, GetUserDetailDatasource> {
  GetUserCacheDetailRepository({
    required super.dataSource,
  }) : super(refreshDuration: const Duration(seconds: 2));

  @override
  Future<Either<RepositoryError, RemoteUser>> call({
    required NoParams repositoryParams,
  });
}
