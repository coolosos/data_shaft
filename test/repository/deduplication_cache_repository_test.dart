import 'package:data_shaft/src/issues/datasource_exception/inadmissible_data_source_exception.dart';
import 'package:data_shaft/src/issues/datasource_exception/un_control_data_source_exception.dart';
import 'package:data_shaft/src/issues/repository_error/inadmissible_repository_error.dart';
import 'package:data_shaft/src/issues/repository_error/on_exception_repository_error.dart';
import 'package:data_shaft/src/issues/repository_error/un_control_repository_error.dart';
import 'package:test/test.dart';

import '../datasource/mock/user_remote_datasource_mock.dart';
import 'mock/user_repository_mock.dart';

void main() {
  late UserDataSourceMock dataSource;
  late UserDataSourceThrowMock dataSourceThrowMock;
  late UserRepositoryMock repository;
  late UserRepositoryThrowMock repositoryThrow;

  setUp(() {
    dataSource = UserDataSourceMock();
    repository = UserRepositoryMock(
      dataSource: dataSource,
      refreshDuration: const Duration(seconds: 2),
    );
    dataSourceThrowMock = UserDataSourceThrowMock();
    repositoryThrow = UserRepositoryThrowMock(
      dataSource: dataSourceThrowMock,
      refreshDuration: const Duration(seconds: 2),
    );
  });

  group('DeduplicationCacheRepository Tests', () {
    test(
        'Should call DataSource only once when multiple simultaneous calls are made',
        () async {
      dataSource.delay = const Duration(milliseconds: 100);
      const params = UserParams(id: '1');

      final results = await Future.wait([
        repository.call(repositoryParams: params),
        repository.call(repositoryParams: params),
        repository.call(repositoryParams: params),
      ]);

      expect(dataSource.callCount, 1);
      for (final result in results) {
        expect(result.isRight(), true);
      }
    });

    test('Should return cached data if refreshDuration has not expired',
        () async {
      const params = UserParams(id: '1');

      await repository.call(repositoryParams: params);
      expect(dataSource.callCount, 1);

      final result = await repository.call(repositoryParams: params);

      expect(dataSource.callCount, 1);
      expect(result.isRight(), true);
    });

    test('Should call DataSource again after cache expires', () async {
      const params = UserParams(id: '1');

      await repository.call(repositoryParams: params);
      expect(dataSource.callCount, 1);

      await Future.delayed(const Duration(seconds: 2, milliseconds: 100));

      await repository.call(repositoryParams: params);
      expect(dataSource.callCount, 2);
    });
  });

  group('Safe Error Handling Tests', () {
    test(
        'Should return UnControlRepositoryError when DataSource throws UnControlDataSourceException',
        () async {
      dataSourceThrowMock.errorToThrow = const UnControlDataSourceException(
        message: 'Server Error',
        statusCode: 500,
      );

      final result = await repositoryThrow.call(
        repositoryParams: const UserParams(id: '1'),
      );

      expect(result.isLeft(), true);
      result.fold(
        (error) => expect(error, isA<UnControlRepositoryError>()),
        (_) => fail('Should have been a Left'),
      );
    });

    test(
        'Should return InadmissibleRepositoryError when DataSource throws InadmissibleDataSourceException',
        () async {
      dataSourceThrowMock.errorToThrow = const InadmissibleDataSourceException(
        message: 'Not Found',
        body: 'Not Found',
        statusCode: 404,
      );

      final result = await repositoryThrow.call(
        repositoryParams: const UserParams(id: '1'),
      );

      expect(result.isLeft(), true);
      result.fold(
        (error) => expect(error, isA<InadmissibleRepositoryError>()),
        (_) => fail('Should have been a Left'),
      );
    });

    test(
        'Should return OnExceptionRepositoryError for unexpected generic exceptions',
        () async {
      dataSourceThrowMock.errorToThrow = Exception('Unexpected logic error');

      final result = await repositoryThrow.call(
        repositoryParams: const UserParams(id: '1'),
      );

      expect(result.isLeft(), true);
      result.fold(
        (error) => expect(error, isA<OnExceptionRepositoryError>()),
        (_) => fail('Should have been a Left'),
      );
    });

    test('Should NOT cache the result if the call fails', () async {
      dataSourceThrowMock.errorToThrow = Exception('Network down');
      await repositoryThrow.call(repositoryParams: const UserParams(id: '1'));

      expect(repositoryThrow.isCached(), false);

      dataSourceThrowMock.errorToThrow = null;
      await repositoryThrow.call(repositoryParams: const UserParams(id: '1'));

      expect(dataSourceThrowMock.callCount, 2);
      expect(repositoryThrow.isCached(), true);
    });
    test('Simultaneous calls should all receive the same error result',
        () async {
      dataSourceThrowMock
        ..errorToThrow = const UnControlDataSourceException(message: 'Fail')
        ..delay = const Duration(milliseconds: 50);

      final results = await Future.wait([
        repositoryThrow.call(repositoryParams: const UserParams(id: '1')),
        repositoryThrow.call(repositoryParams: const UserParams(id: '1')),
      ]);

      expect(results[0].isLeft(), true);
      expect(results[1].isLeft(), true);

      expect(results[0], results[1]);
    });
  });
}
