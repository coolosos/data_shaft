import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/datasource.dart';
import 'package:data_shaft/observers.dart';
import 'package:test/test.dart';

import '../datasource/mock/mock_driver.dart';
import '../datasource/mock/remote/test_get_datasource.dart';
import '../repository/mock/user_repository_mock.dart';
import 'mock/datasource_observer_mock.dart';

void main() {
  test('Observer Full Flow: HttpObserver and SimpleObserver', () async {
    final driver = MockRemoteDriver();
    final remoteDatasourceObserver = CustomRemoteObserver();
    final datasourceObserver = CustomDatasourceObserver();

    DatasourceObserverInstances.httpDatasourceObserver =
        remoteDatasourceObserver;
    DatasourceObserverInstances.datasourceObserver = datasourceObserver;

    final dataSource = TestGetDataSource(driver: driver);
    final repository = UserRepositoryFlowMock(
      dataSource: dataSource,
      refreshDuration: const Duration(seconds: 1),
    );

    driver.simulatedResponse = const RequestResponse(
      statusCode: 200,
      body: '{"name": "Data Shaft User"}',
      originalResponse: null,
    );

    await repository.call(repositoryParams: const NoParams());
    expect(remoteDatasourceObserver.isOnUriCreation, 1);
    expect(remoteDatasourceObserver.isOnCreateCall, 1);
    expect(datasourceObserver.isOnCreateCall, 0);
    expect(remoteDatasourceObserver.isOnDriverException, 0);
    driver.throwable = UnimplementedError();
    await Future.delayed(const Duration(seconds: 1));
    await repository.call(repositoryParams: const NoParams());
    expect(remoteDatasourceObserver.isOnCreateCall, 1);
    expect(remoteDatasourceObserver.isOnUriCreation, 2);
    expect(remoteDatasourceObserver.isOnDriverException, 1);
  });
}
