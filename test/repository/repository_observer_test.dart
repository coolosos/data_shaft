import 'package:data_shaft/src/observers/repository/repository_observer_instances.dart';
import 'package:test/test.dart';

import '../datasource/mock/user_remote_datasource_mock.dart';
import 'mock/user_repository_mock.dart';

class TestSafeObserver implements SafeCallableRepositoryObserver {
  bool onCreateCalled = false;
  bool beforeCallCalled = false;
  bool exceptionCalled = false;
  String? lastCallableName;

  @override
  void onCreate(String name) => onCreateCalled = true;

  @override
  void onDispose(String name) {}

  @override
  void beforeCall(String name, String callableName) {
    beforeCallCalled = true;
    lastCallableName = name;
  }

  @override
  void afterCall(String name, String datasourceName, Object? datasourceValue) {}

  @override
  void onException(
    Object exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {
    exceptionCalled = true;
  }

  @override
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {
    exceptionCalled = true;
  }

  @override
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {
    exceptionCalled = true;
  }
}

void main() {
  late UserDataSourceMock dataSource;
  late UserRepositoryMock repository;
  late TestSafeObserver observer;

  setUp(() {
    observer = TestSafeObserver();

    RepositoryObserverInstances.safeCallableObserver = observer;
    RepositoryObserverInstances.repositoryObserver = observer;

    dataSource = UserDataSourceMock();
    repository = UserRepositoryMock(
      dataSource: dataSource,
      refreshDuration: const Duration(seconds: 1),
    );
  });

  group('Repository Observer Integration Tests', () {
    test('Should notify onCreate when repository is instantiated', () {
      expect(observer.onCreateCalled, true);
    });

    test('Should notify beforeCall when repository call is executed', () async {
      await repository.call(repositoryParams: const UserParams(id: '1'));

      expect(observer.beforeCallCalled, true);
      expect(observer.lastCallableName, contains('UserRepositoryMock'));
    });

    test('Should notify onException when an unexpected error occurs', () async {
      final datasource = UserDataSourceThrowMock()
        ..errorToThrow = Exception('Generic Error');

      await UserRepositoryThrowMock(
        dataSource: datasource,
        refreshDuration: const Duration(seconds: 1),
      ).call(repositoryParams: const UserParams(id: '1'));

      expect(observer.exceptionCalled, true);
    });
  });
}
