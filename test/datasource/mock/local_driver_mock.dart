import 'package:data_shaft/src/datasources/driver/driver.dart';

class MockLocalDriver implements Driver {
  // Almacenamiento simulado en memoria
  final Map<String, dynamic> storage = {};

  void write(String key, dynamic value) => storage[key] = value;
  dynamic read(String key) => storage[key];
  void remove(String key) => storage.remove(key);
}
