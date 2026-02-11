import 'package:data_shaft/src/repository/repository.dart';

import '../../datasource/mock/mock_driver.dart';
import '../../datasource/mock/remote/test_get_datasource.dart';
import '../../datasource/mock/user_remote_datasource_mock.dart';

class UserRepositoryMock
    extends DeduplicationCacheRepository<User, UserDataSourceMock> {
  UserRepositoryMock({
    required super.dataSource,
    required super.refreshDuration,
  });
}

class UserRepositoryThrowMock
    extends DeduplicationCacheRepository<User, UserDataSourceThrowMock> {
  UserRepositoryThrowMock({
    required super.dataSource,
    required super.refreshDuration,
  });
}

class UserRepositoryFlowMock
    extends DeduplicationCacheRepository<MockModel, TestGetDataSource> {
  UserRepositoryFlowMock({
    required super.dataSource,
    required super.refreshDuration,
  });
}
