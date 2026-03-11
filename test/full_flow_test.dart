import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/datasource.dart';
import 'package:data_shaft/observers.dart';
import 'package:test/test.dart';

import 'datasource/mock/mock_driver.dart';
import 'datasource/mock/remote/test_get_datasource.dart';
import 'repository/mock/user_repository_mock.dart';
import 'repository/repository_observer_test.dart';

void main() {
  test('Full Flow: Remote -> DataSource -> Repository (Cache + Observer)',
      () async {
    final driver = MockRemoteDriver();
    final observer = TestSafeObserver();
    RepositoryObserverInstances.safeCallableObserver = observer;

    final dataSource = TestGetDataSource(driver: driver);
    final repository = UserRepositoryFlowMock(
      dataSource: dataSource,
      refreshDuration: const Duration(minutes: 5),
    );

    driver.simulatedResponse = RequestResponse(
      statusCode: 200,
      body: () => '{"name": "Data Shaft User"}',
      originalResponse: null,
    );

    final result = await repository.call(repositoryParams: const NoParams());

    expect(result.isRight(), true);
    result.fold((_) => null, (user) => expect(user.name, 'Data Shaft User'));

    expect(observer.beforeCallCalled, true);

    expect(repository.isCached(), true);

    await repository.call(repositoryParams: const NoParams());
    expect(dataSource.callCount, 1);
  });
}
