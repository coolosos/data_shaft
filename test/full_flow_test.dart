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
    // 1. INFRAESTRUCTURA MOCK
    final driver = MockRemoteDriver();
    final observer = TestSafeObserver();
    RepositoryObserverInstances.safeCallableObserver = observer;

    // 2. CAPA DE DATOS
    final dataSource = TestGetDataSource(driver: driver);
    final repository = UserRepositoryFlowMock(
      dataSource: dataSource,
      refreshDuration: const Duration(minutes: 5),
    );

    // 3. SIMULAR RESPUESTA EXITOSA
    driver.simulatedResponse = const RequestResponse(
      statusCode: 200,
      body: '{"name": "Data Shaft User"}',
      originalResponse: null,
    );

    // 4. EJECUCIÓN
    final result = await repository.call(repositoryParams: const NoParams());

    // 5. VERIFICACIONES CIUDADANAS
    expect(result.isRight(), true);
    result.fold((_) => null, (user) => expect(user.name, 'Data Shaft User'));

    // Verificamos que pasó por el observer
    expect(observer.beforeCallCalled, true);

    // Verificamos que se guardó en caché (el repo debe estar en cache ahora)
    expect(repository.isCached(), true);

    // Verificamos que la segunda llamada no use el driver (caché activa)
    await repository.call(repositoryParams: const NoParams());
    expect(dataSource.callCount, 1); // Se mantiene en 1 por la caché
  });
}
