import 'driver.dart';

/// {@template data_shaft.basic_driver}
/// An abstract base class for [Driver] implementations designed to handle
/// **basic, key-value data operations**.
///
/// This driver is typically used for local data storage, such as shared preferences,
/// local configuration files, or in-memory caches. It provides the necessary
/// contract for `set`, `get`, and `delete` operations based on a unique key.
///
/// Implementations of this class should focus on fast, synchronous (or near-synchronous)
/// local data access.
/// {@endtemplate}
abstract base class BasicDriver<T> extends Driver {
  /// {@macro data_shaft.basic_driver}
  const BasicDriver();

  /// Checks if a value associated with the given [key] exists in the storage.
  ///
  /// Returns `true` if the key exists, `false` otherwise.
  Future<bool> containsKey({required String key});

  /// Deletes the value associated with the given [key] from the storage.
  ///
  /// If the key does not exist, the operation should complete without throwing an error.
  Future<void> delete({required String key});

  /// Deletes all key-value pairs stored by this driver.
  Future<void> deleteAll();

  /// Retrieves the value of type [T] associated with the given [key].
  ///
  /// Returns the stored value if the key exists, or `null` if the key is not found.
  Future<T?> get({required String key});

  /// Stores or updates the given [value] associated with the unique [key].
  ///
  /// This method is guaranteed to complete the storage operation.
  Future<void> set({required String key, required T value});
}
