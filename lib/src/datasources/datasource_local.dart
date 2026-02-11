import 'package:meta/meta.dart';

import 'datasource.dart';
import 'driver/driver.dart';

/// {@template data_shaft.datasource_local}
/// An abstract [DataSource] designed to manage a single, uniquely identifiable
/// piece of data stored locally (e.g., configurations, tokens, preferences).
///
/// This class represents a local source of truth for a specific data item.
/// It enforces the use of a unique [key] and delegates read, write, and
/// delete operations to the injected [driver].
///
/// - [ValueType]: The type of data being managed and stored.
/// - [D]: The specific type of [Driver] implementation used for storage (e.g., BasicDriver).
/// {@endtemplate}
abstract class DatasourceLocal<ValueType, D extends Driver> extends DataSource {
  /// {@macro data_shaft.datasource_local}
  DatasourceLocal(this.driver);

  /// The underlying [Driver] responsible for handling the low-level storage
  /// operations (e.g., reading/writing to Shared Preferences or Hive).
  final D driver;

  /// The unique key used to identify and retrieve the [ValueType] in the
  /// underlying storage.
  String get key;

  /// Stores the given [value] into the local storage using the defined [key].
  ///
  /// If [value] is `null`, this method delegates to the [delete] method.
  ///
  /// Throws an assertion error in debug mode if `value` is `null`, but handles
  /// the deletion gracefully in release mode.
  Future<void> put(ValueType? value) async {
    if (value == null) {
      await delete();
    } else {
      await save(value);
    }
  }

  /// Internal method responsible for the concrete storage operation.
  ///
  /// Must implement this to handle the actual saving logic using the [driver].
  @protected
  Future<void> save(ValueType value);

  /// Retrieves the stored value from the local storage.
  ///
  /// This is an alias for the [read] getter, allowing the instance to be
  /// called like a function (e.g., `await localDataSource()`).
  Future<ValueType?> call() => read;

  /// Retrieves the stored value from the local storage.
  ///
  /// Returns the stored value if found, or `null` if the key does not exist.
  Future<ValueType?> get read;

  /// Removes the stored value associated with the [key] from the local storage.
  Future<void> delete();
}
