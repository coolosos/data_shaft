import 'dart:async';

import 'package:data_shaft/src/datasources/datasource_streamable.dart';
import 'package:data_shaft/src/observers/repository/repository_observer_instances.dart';
import 'package:data_shaft/src/repository/repository_datasource_callable.dart';
import 'package:data_shaft/src/repository/repository_datasource_streamable.dart';
import 'package:test/test.dart';

import '../datasource/mock/user_remote_datasource_mock.dart';
import 'mock/user_repository_mock.dart';

class TestSafeObserver implements SafeCallableRepositoryObserver {
  bool onCreateCalled = false;
  bool beforeCallCalled = false;
  bool exceptionCalled = false;
  bool onDisposeCalled = false;
  String? lastRepositoryName;

  @override
  void onCreate(String repositoryName) => onCreateCalled = true;

  @override
  void onDispose(String repositoryName) => onDisposeCalled = true;

  @override
  void beforeCall(
    String repositoryName,
    String datasourceName, {
    required DateTime startTime,
  }) {
    beforeCallCalled = true;
    lastRepositoryName = repositoryName;
  }

  @override
  void afterCall(
    String repositoryName,
    String datasourceName,
    Object? datasourceValue, {
    required DateTime endTime,
    required Duration elapsed,
  }) {}

  @override
  void onException(
    Object exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  }) {
    exceptionCalled = true;
  }

  @override
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  }) {
    exceptionCalled = true;
  }

  @override
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  }) {
    exceptionCalled = true;
  }
}

void main() {
  tearDown(RepositoryObserverInstances.reset);

  group('Repository Observer Integration Tests', () {
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

    test('Should notify onCreate when repository is instantiated', () {
      expect(observer.onCreateCalled, true);
    });

    test('Should notify beforeCall when repository call is executed', () async {
      await repository.call(repositoryParams: const UserParams(id: '1'));

      expect(observer.beforeCallCalled, true);
      expect(observer.lastRepositoryName, contains('UserRepositoryMock'));
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

    test('Should notify onDispose when repository is disposed', () {
      repository.dispose();
      expect(observer.onDisposeCalled, true);
    });
  });

  group('useHigherObserver', () {
    test(
        'flag=false: repositoryObserver does NOT fallback to safeCallableObserver',
        () {
      final safeObs = TestSafeObserver();
      RepositoryObserverInstances.safeCallableObserver = safeObs;

      expect(
        identical(
          RepositoryObserverInstances.repositoryObserver,
          safeObs,
        ),
        false,
      );
      expect(
        identical(
          RepositoryObserverInstances.repositoryDatasourceCallableObserver,
          safeObs,
        ),
        false,
      );
    });

    test(
        'flag=true: repositoryObserver and repositoryDatasourceCallableObserver '
        'fallback to safeCallableObserver', () {
      final safeObs = TestSafeObserver();
      RepositoryObserverInstances.safeCallableObserver = safeObs;
      RepositoryObserverInstances.useHigherObserver = true;

      expect(
        identical(
          RepositoryObserverInstances.repositoryObserver,
          safeObs,
        ),
        true,
      );
      expect(
        identical(
          RepositoryObserverInstances.repositoryDatasourceCallableObserver,
          safeObs,
        ),
        true,
      );
    });

    test(
        'flag=true: repositoryDatasourceCallableObserver is used as fallback '
        'for repositoryObserver', () {
      final callableObs = TestSafeObserver();
      RepositoryObserverInstances.repositoryDatasourceCallableObserver =
          callableObs;
      RepositoryObserverInstances.useHigherObserver = true;

      expect(
        identical(
          RepositoryObserverInstances.repositoryObserver,
          callableObs,
        ),
        true,
      );
    });

    test('flag=true: explicit assignment still takes priority over fallback',
        () {
      final explicitObs = TestSafeObserver();
      final safeObs = TestSafeObserver();
      RepositoryObserverInstances.repositoryObserver = explicitObs;
      RepositoryObserverInstances.safeCallableObserver = safeObs;
      RepositoryObserverInstances.useHigherObserver = true;

      expect(
        identical(
          RepositoryObserverInstances.repositoryObserver,
          explicitObs,
        ),
        true,
      );
    });

    test('flag=true with no observers set returns default without throwing',
        () {
      RepositoryObserverInstances.useHigherObserver = true;

      expect(RepositoryObserverInstances.repositoryObserver, isNotNull);
      expect(
        RepositoryObserverInstances.repositoryDatasourceCallableObserver,
        isNotNull,
      );
    });
  });

  group('default observer implementations', () {
    test(
        '_DefaultRepositoryImp should handle onDispose, beforeCall and afterCall',
        () async {
      final dataSource = UserDataSourceMock();
      final repo = _DirectCallableRepo(dataSource: dataSource);

      final result = await repo.call(
        repositoryParams: const UserParams(id: '1'),
      );

      expect(result.isRight(), true);
      repo.dispose();
    });

    test('_DefaultSafeRepository should handle onCreate and onDispose',
        () async {
      final repo = UserRepositoryMock(
        dataSource: UserDataSourceMock(),
        refreshDuration: const Duration(seconds: 1),
      );

      // ignore: cascade_invocations
      repo.dispose();
    });

    test(
        '_DefaultRepositoryDataSourceStreamableObserverImpl should handle lifecycle',
        () async {
      final dataSource = _StreamableDataSourceMock();
      final repo = _StreamableRepoMock(dataSource: dataSource);

      final stream = repo.stream(params: const UserParams(id: '1'));
      expect(stream, isA<Stream<String>>());

      repo.dispose();
    });

    test(
        '_DefaultSafeRepository.onCreate and onDispose are callable through '
        'the public getter', () {
      RepositoryObserverInstances.safeCallableObserver
        ..onCreate('test_repo')
        ..onDispose('test_repo');
    });

    test(
        '_DefaultRepositoryDataSourceStreamableObserverImpl.onCreate and '
        'onDispose are callable through the public getter', () {
      RepositoryObserverInstances.repositoryDataSourceStreamableObserver
        ..onCreate('test_repo')
        ..onDispose('test_repo');
    });
  });
}

class _DirectCallableRepo
    extends RepositoryDataSourceCallable<User, UserDataSourceMock> {
  _DirectCallableRepo({required super.dataSource});
}

class _StreamableDataSourceMock extends DataSourceStreamable<String> {
  @override
  Stream<String> stream({required covariant Params params}) {
    return Stream.value('data');
  }
}

class _StreamableRepoMock
    extends RepositoryDataSourceStreamable<String, _StreamableDataSourceMock> {
  _StreamableRepoMock({required super.dataSource});
}
