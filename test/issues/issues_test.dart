import 'package:data_shaft/issues.dart';
import 'package:test/test.dart';

void main() {
  group('InadmissibleDataSourceException', () {
    test('exposes its fields and a descriptive toString', () {
      final exception = InadmissibleDataSourceException(
        body: '{"error": "nope"}',
        statusCode: 404,
        requestUri: Uri.parse('https://api.test/users/1'),
        requestHeaders: const {'auth': 'token'},
        requestBody: '{"id": 1}',
        message: 'Not found',
      );

      expect(exception.body, '{"error": "nope"}');
      expect(exception.statusCode, 404);
      expect(exception.requestUri, Uri.parse('https://api.test/users/1'));
      expect(exception.requestHeaders, {'auth': 'token'});
      expect(exception.requestBody, '{"id": 1}');
      expect(exception.message, 'Not found');
      expect(exception.toString(), contains('404'));
      expect(exception.toString(), contains('nope'));
    });

    test('equality is props-based', () {
      const a = InadmissibleDataSourceException(body: 'x', statusCode: 400);
      const b = InadmissibleDataSourceException(body: 'x', statusCode: 400);
      const c = InadmissibleDataSourceException(body: 'x', statusCode: 500);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });

  group('UnControlDataSourceException', () {
    test('exposes its fields and a descriptive toString', () {
      const exception = UnControlDataSourceException(
        body: 'boom',
        statusCode: 503,
        reasonPhrase: 'Service Unavailable',
        message: 'Server error',
      );

      expect(exception.body, 'boom');
      expect(exception.statusCode, 503);
      expect(exception.reasonPhrase, 'Service Unavailable');
      expect(exception.message, 'Server error');
      expect(exception.toString(), contains('503'));
      expect(exception.toString(), contains('Service Unavailable'));
    });

    test('equality is props-based', () {
      const a = UnControlDataSourceException(
        statusCode: 500,
        body: 'x',
        reasonPhrase: 'r',
      );
      const b = UnControlDataSourceException(
        statusCode: 500,
        body: 'x',
        reasonPhrase: 'r',
      );
      const c = UnControlDataSourceException(
        statusCode: 500,
        body: 'x',
        reasonPhrase: 'R',
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });

  group('InadmissibleRepositoryError', () {
    test('uses defaults when no context is provided', () {
      const error = InadmissibleRepositoryError();

      expect(error.message, 'Inadmissible result from Data Source');
      expect(error.statusCode, isNull);
      expect(error.body, isNull);
    });

    test('equality is props-based', () {
      const a = InadmissibleRepositoryError(
        message: 'm',
        statusCode: 404,
        body: 'x',
      );
      const b = InadmissibleRepositoryError(
        message: 'm',
        statusCode: 404,
        body: 'x',
      );
      const c = InadmissibleRepositoryError(
        message: 'm',
        statusCode: 500,
        body: 'x',
      );

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });

  group('OnExceptionRepositoryError', () {
    test('uses its default message and equality is props-based', () {
      const error = OnExceptionRepositoryError();

      expect(error.message, 'Error during Repository orchestration');
      expect(
        const OnExceptionRepositoryError(),
        equals(const OnExceptionRepositoryError()),
      );
    });
  });

  group('UnControlRepositoryError', () {
    test('uses defaults when no context is provided', () {
      const error = UnControlRepositoryError();

      expect(error.message, '...');
      expect(error.cause, isNull);
      expect(error.stackTrace, isNull);
    });

    test('carries cause and stackTrace and equality is props-based', () {
      final trace = StackTrace.current;
      const a = UnControlRepositoryError(message: 'm', cause: Object());
      const b = UnControlRepositoryError(message: 'm', cause: Object());
      final c = UnControlRepositoryError(
        message: 'm',
        cause: Object(),
        stackTrace: trace,
      );

      expect(a.cause, isA<Object>());
      expect(c.stackTrace, same(trace));
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });
}
