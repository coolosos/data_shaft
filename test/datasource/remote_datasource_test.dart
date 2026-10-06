import 'dart:convert';

import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/datasource.dart';
import 'package:data_shaft/src/issues/datasource_exception/inadmissible_data_source_exception.dart';
import 'package:data_shaft/src/issues/datasource_exception/un_control_data_source_exception.dart';
import 'package:test/test.dart';

import 'mock/mock_driver.dart';
import 'mock/path_test_datasource_mock.dart';
import 'mock/remote/test_delete_datasource.dart';
import 'mock/remote/test_get_datasource.dart';
import 'mock/remote/test_head_datasource.dart';
import 'mock/remote/test_patch_datasource.dart';
import 'mock/remote/test_post_datasource.dart';
import 'mock/remote/test_put_datasource.dart';

void main() {
  final remoteDatasources =
      <
        String,
        DatasourceRemote<MockModel, MockRemoteDriver> Function(MockRemoteDriver)
      >{
        'Get': (d) => TestGetDataSource(driver: d),
        'Head': (d) => TestHeadDataSource(driver: d),
        'Post': (d) => TestPostDataSource(driver: d),
        'Patch': (d) => TestPatchDataSource(driver: d),
        'Put': (d) => TestPutDataSource(driver: d),
        'Delete': (d) => TestDeleteDataSource(driver: d),
      };

  for (final entry in remoteDatasources.entries) {
    late MockRemoteDriver driver;
    group('DatasourceRemote ${entry.key} Logic Tests', () {
      late DatasourceRemote<MockModel, MockRemoteDriver> dataSource;

      setUp(() {
        driver = MockRemoteDriver();
        dataSource = entry.value(driver);
      });

      test(
        'Should build URI correctly with pathPrefix and pathModification',
        () {
          final uri = dataSource.uri;

          expect(uri.toString(), 'https://api.test.com/users/123');
        },
      );

      test(
        'Should merge query parameters from generateCallRequirement',
        () async {
          driver.simulatedResponse = RequestResponse(
            statusCode: 200,
            body: () => '{"name": "Test User"}',
            originalResponse: null,
          );

          await dataSource.call(params: const NoParams());

          expect(driver.lastUri.toString(), contains('version=1'));
        },
      );

      test('Should throw InadmissibleDataSourceException on defined inadmissible code', () async {
        driver.simulatedResponse = RequestResponse(
          statusCode: 404,
          body: () => 'Not Found',
          originalResponse: null,
        );

        expect(
          () => dataSource.call(params: const NoParams()),
          throwsA(isA<InadmissibleDataSourceException>()),
        );
      });

      test(
        'Should throw UnControlDataSourceException on non-admissible code',
        () async {
          driver.simulatedResponse = RequestResponse(
            statusCode: 500,
            body: () => 'Internal Server Error',
            originalResponse: null,
          );

          expect(
            () => dataSource.call(params: const NoParams()),
            throwsA(isA<UnControlDataSourceException>()),
          );
        },
      );

      test('Should return transformed object on success (200)', () async {
        driver.simulatedResponse = RequestResponse(
          statusCode: 200,
          body: () => '{"name": "Dart User"}',
          originalResponse: null,
        );

        final result = await dataSource.call(params: const NoParams());

        expect(result.name, 'Dart User');
        expect(result, isA<MockModel>());
      });
    });
  }

  group('DatasourceRemote Path Construction & Modification Coverage', () {
    late MockRemoteDriver driver;

    setUp(() => driver = MockRemoteDriver());

    test('Should apply pathModification correctly', () async {
      final dataSource = TestGetDataSource(driver: driver);
      // path => '/users/:id' and pathModification => {':id': '123'}

      final uri = dataSource.uri;

      expect(uri.path, contains('/users/123'));
    });

    test('Should handle pathPrefix correctly when path is empty ', () {
      final dataSource = PathTestDataSource(
        driver: driver,
        customPath: '',
        customPrefix: '/api/v1',
      );

      expect(dataSource.uri.path, '/api/v1');
    });

    test('Should handle double slashes by removing one', () {
      final dataSource = PathTestDataSource(
        driver: driver,
        customPath: '/users',
        customPrefix: '/api/',
      );
      // prefix ends with / AND path starts with /
      expect(dataSource.uri.path, '/api/users');
    });

    test('Should add a slash if neither prefix nor path have it', () {
      final dataSource = PathTestDataSource(
        driver: driver,
        customPath: 'users',
        customPrefix: 'api',
      );
      // prefix NOT ends with / AND path NOT starts with /
      expect(dataSource.uri.path, '/api/users');
    });

    test('Should concatenate directly if only one has a slash ', () {
      final dataSource = PathTestDataSource(
        driver: driver,
        customPath: 'users',
        customPrefix: '/api/',
      );

      expect(dataSource.uri.path, '/api/users');
    });

    test(
      'Should replace every occurrence of a repeated token in pathModification',
      () {
        final dataSource = _RepeatedTokenDataSource(driver: driver);

        final uri = dataSource.uri;

        expect(uri.path, '/users/42/posts/42');
      },
    );

    test(
      'Should use default inadmissibleStatusCode when not overridden',
      () async {
        driver.simulatedResponse = RequestResponse(
          statusCode: 200,
          body: () => '{"name": "Test"}',
          originalResponse: null,
        );

        final dataSource = PathTestDataSource(
          driver: driver,
          customPath: '/users',
          customPrefix: '',
        );

        final result = await dataSource.call(params: const NoParams());
        expect(result, isA<MockModel>());
      },
    );
  });

  group('DatasourceRemote Body Coverage', () {
    test('Should pass body to observer call and driver exception', () async {
      final driver = MockRemoteDriver()
        ..simulatedResponse = RequestResponse(
          statusCode: 200,
          body: () => '{"name": "Test"}',
          originalResponse: null,
        );

      final dataSource = _BodyTestDataSource(driver: driver);

      await dataSource.call(params: const NoParams());

      expect(driver.lastBody, '{"key": "value"}');
      expect(driver.lastEncoding, utf8);
      expect(driver.lastOptions, <String, Object?>{'dioCancel': true});

      driver.throwable = UnimplementedError();
      expect(
        () => dataSource.call(params: const NoParams()),
        throwsA(isA<Error>()),
      );
    });
  });

  group('DatasourceRemote Options/Encoding Coverage', () {
    late MockRemoteDriver driver;

    setUp(() => driver = MockRemoteDriver());

    test('Should forward driverOptions to the driver on GET', () async {
      driver.simulatedResponse = RequestResponse(
        statusCode: 200,
        body: () => '{"name": "Test"}',
        originalResponse: null,
      );

      final dataSource = TestGetDataSource(driver: driver);

      await dataSource.call(params: const NoParams());

      expect(driver.lastOptions, <String, Object?>{'source': 'test_get'});
    });

    test('Should forward driverOptions to the driver on HEAD', () async {
      driver.simulatedResponse = RequestResponse(
        statusCode: 200,
        body: () => '{"name": "Test"}',
        originalResponse: null,
      );

      final dataSource = TestHeadDataSource(driver: driver);

      await dataSource.call(params: const NoParams());

      expect(driver.lastOptions, <String, Object?>{'source': 'test_head'});
    });
  });
}

final class _RepeatedTokenDataSource
    extends DatasourceGetRemote<MockModel, MockRemoteDriver> {
  new({required super.driver});

  @override
  String get host => 'https://test.com';

  @override
  String get path => '/users/:id/posts/:id';

  @override
  Map<String, String> get pathModification => {':id': '42'};

  @override
  Set<int> get admissibleStatusCode => {200};

  @override
  MockModel transformation({
    required covariant RequestResponse<Object?> remoteResponse,
  }) => const MockModel(name: '');

  @override
  GetParams generateCallRequirement({required Params params}) =>
      const GetParams();
}

final class _BodyTestDataSource
    extends DatasourcePostRemote<MockModel, MockRemoteDriver> {
  new({required super.driver});

  @override
  String get host => 'https://api.test.com';

  @override
  String? get path => '/test';

  @override
  Set<int> get admissibleStatusCode => {200};

  @override
  PostParams generateCallRequirement({required Params params}) => PostParams(
    encodeBody: () => '{"key": "value"}',
    encoding: utf8,
    driverOptions: <String, Object?>{'dioCancel': true},
  );

  @override
  MockModel transformation({
    required covariant RequestResponse<Object?> remoteResponse,
  }) => const MockModel(name: 'test');
}
