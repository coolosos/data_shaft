import 'package:test/test.dart';

import 'mock/local_driver_mock.dart';
import 'mock/test_local_datasource.dart';

void main() {
  late MockLocalDriver driver;
  late UserLocalDataSource dataSource;

  setUp(() {
    driver = MockLocalDriver();
    dataSource = UserLocalDataSource(driver);
  });

  group('DatasourceLocal Tests', () {
    test('Should save value correctly using put', () async {
      const token = 'abc-123';

      await dataSource.put(token);

      expect(driver.storage[dataSource.key], token);
      expect(await dataSource.read, token);
    });

    test('Should delete value when put receives null', () async {
      driver.storage[dataSource.key] = 'existing-token';

      await dataSource.put(null);

      expect(driver.storage.containsKey(dataSource.key), false);
      expect(await dataSource.read, null);
    });

    test('Should return value when calling the instance (call method)',
        () async {
      const token = 'secret-key';
      await dataSource.put(token);

      final result = await dataSource();

      expect(result, token);
    });

    test('Should remove value when delete is called directly', () async {
      driver.storage[dataSource.key] = 'to-be-deleted';

      await dataSource.delete();

      expect(driver.storage.containsKey(dataSource.key), false);
    });
  });
}
