import 'package:data_shaft/src/datasources/datasource_local.dart';

import 'local_driver_mock.dart';

class UserLocalDataSource extends DatasourceLocal<String, MockLocalDriver> {
  UserLocalDataSource(super.driver);

  @override
  String get key => 'user_token_key';

  @override
  Future<String?> get read async => driver.read(key) as String?;

  @override
  Future<void> save(String value) async {
    driver.write(key, value);
  }

  @override
  Future<void> delete() async {
    driver.remove(key);
  }
}
