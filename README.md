# Data Shaft 🚀

**Data Shaft** is a modular, robust, and type-safe data layer framework for Dart and Flutter. Built on **Clean Architecture** principles, it provides a standardized way to manage remote and local data sources, repositories, and error handling.

This package eliminates boilerplate code and solves common challenges such as error mapping, memory caching, and request deduplication.

[![Pub Version](https://badgen.net/pub/v/data_shaft)](https://pub.dev/packages/data_shaft/)
[![Pub Likes](https://badgen.net/pub/likes/data_shaft)](https://pub.dev/packages/data_shaft/score)
[![Pub Points](https://badgen.net/pub/points/data_shaft)](https://pub.dev/packages/data_shaft/score)
[![Pub Downloads](https://badgen.net/pub/dm/data_shaft)](https://pub.dev/packages/data_shaft)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/data_shaft)](https://pub.dev/packages/data_shaft/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/coolosos/data_shaft/blob/main/LICENSE)
[![](https://img.shields.io/badge/linted%20by-coolint-0553B1)](https://pub.dev/packages/coolint)
[![codecov](https://codecov.io/gh/coolosos/data_shaft/graph/badge.svg)](https://codecov.io/gh/coolosos/data_shaft)

---

## ✨ Key Features

* ✅ **Standardized Remote Drivers**: Decouple your app from HTTP clients (Dio, Http, etc.).
* ✅ **Typed DataSources**: Specialized mixins for GET, POST, PUT, PATCH, and DELETE operations.
* ✅ **Advanced Repository Mixins**: Built-in Memory Cache, Request Deduplication, and Safe Execution.
* ✅ **Full Observability**: Lifecycle and network logging powered by `dart:developer`.
* ✅ **Structured Error Handling**: Automatic mapping from `DataSource` exceptions to `Repository` errors.

---

## 🚀 Implementation Examples

### 1. Implementing the Driver (with Dio)
The `RemoteDriver` acts as an adapter. Here is how you bridge **Dio** with **Data Shaft**:

```dart
import 'package:dio/dio.dart';
import 'package:data_shaft/data_shaft.dart';

class DioRemoteDriver implements RemoteDriver {
  final Dio dio;
  DioRemoteDriver(this.dio);

  @override
  Future<RequestResponse> get(Uri uri, {Map<String, String>? headers, Object? options}) async {
    final response = await dio.getUri(uri, options: options as Options);
    return RequestResponse(
      statusCode: response.statusCode ?? 500,
      body: response.data.toString(),
      headers: response.headers.map.map((k, v) => MapEntry(k, v.join(','))),
      originalResponse: response,
    );
  }

  // Implement post, put, patch, delete following the same pattern...
}
```
### 2. DataSource
#### 2.1 Datasource Pre-build class
DataSources are specialized for specific operations. Use the pre-built base classes to save time:
```dart
class GetUserDataSource extends DatasourceGetRemote<User, MyDriver> {
  GetUserDataSource({required super.driver});

  @override
  GetParams? generateCallRequirement({required Params params}) {
    return GetParams(urlParams: {'id': params.id});
  }
}
```

#### 2.1 Datasource using Mixins
You can use mixins directly on a `DatasourceRemote` to define request behavior without deep inheritance:
```dart
class UpdateUserDataSource extends DatasourceRemote<User, DioRemoteDriver> 
    with PatchCall<User, DioRemoteDriver> {
  UpdateUserDataSource({required super.driver});

  @override
  PatchParams generateCallRequirement({required Params params}) {
    return PatchParams(
      encodeBody: () => json.encode({'name': params.name}),
    );
  }
}
```
### 3. Safe Repository Execution
The `SafeRepositoryDatasourceCallable` catches all exceptions and converts them into `Either` types, shielding your Domain layer from crashes:

```dart
// The Repository handles safety, mapping, and deduplication
final class GetUserDetailRepository extends DeduplicationRepository<User, GetUserDataSource> {
  GetUserDetailRepository({required super.dataSource});
  
  // Calling this repository returns: Future<Either<RepositoryError, User>>
}

// Usage in a Bloc, Controller, or UseCase:
final result = await userRepository(repositoryParams: UserParams(id: '123'));

result.fold(
  (error) => print('Error: ${error.message}'), // Inadmissible, UnControl, etc.
  (user) => print('User loaded: ${user.name}'),
);
```
#### 3.1 Repository using Mixins
You can use mixins directly on a `Repository` to define datasource reply without deep inheritance:

```dart
class GetUserDetailRepository extends RepositoryDataSourceCallable<User, GetUserDataSource>
    with DeduplicationManagement<User, GetUserDataSource>, SafeRepositoryHelper<User> {
  
  GetUserDetailRepository({required super.dataSource});

  @override
  Future<Either<RepositoryError, User>> call({
    required covariant Params repositoryParams,
  }) async {
    return safeCall(
      call: () => super.call(repositoryParams: repositoryParams),
    );
  }

  @override
  RepositoryError Function(InadmissibleDataSourceException, StackTrace)
      get onInadmissibleException => (exception, stackTrace) {
            return InadmissibleRepositoryError(
              message: 'User not found or unauthorized access',
            );
          };

  @override
  RepositoryError Function(UnControlDataSourceException, StackTrace)
      get onUnControlException => (exception, stackTrace) {
            return const UnControlRepositoryError(
              message: 'Communication error with the remote server',
            );
          };

  @override
  RepositoryError Function(Object, StackTrace) 
      get onException => (exception, stackTrace) {
            return const OnExceptionRepositoryError(
              message: 'Unexpected error during user data processing',
            );
          };
}
```
---

## 🛠 Layered Architecture

### 🛡 Safety First
The framework manages three error levels to ensure your UI never receives an unhandled exception:
* **`InadmissibleRepositoryError`**: Controlled business failures (e.g., 404 Not Found).
* **`OnExceptionRepositoryError`**: Failures during data transformation or orchestration.
* **`UnControlRepositoryError`**: Unexpected failures (Null pointers, unexpected types).

### ⏱ Smart Caching
Use `SafeMemoryCacheRepository` to get an out-of-the-box memory cache with a configurable `refreshDuration`.

### 👯 Deduplication
Prevent redundant requests. If two identical calls are triggered simultaneously, `DeduplicationManagement` ensures both wait for the same result, saving bandwidth and backend resources.

---

## 📊 Observability

**Data Shaft** features an integrated logging system using `dart:developer` tags. You can filter your console by `DS.REMOTE` to see network traffic or `REPO` to see business logic flow.

```dart
// Example console output:
// [DS.REMOTE.GetUserDataSource] 🔛 CALLING: [https://api.com/user/1](https://api.com/user/1)
// [REPO.GetUserRepository] ✅ Safe Call Complete | Result: Instance of 'User' | Elapsed: 42ms
```

Customize logging by implementing `HttpDatasourceObserver` or `RepositoryObserver`:

```dart
DatasourceObserverInstances.httpDatasourceObserver = MyCustomLogStrategy();
```

If you only implement a higher-level observer (e.g. `HttpDatasourceObserver`) and want it to also receive basic lifecycle events (`onCreate`, `onDispose`), enable the fallback:

```dart
DatasourceObserverInstances.httpDatasourceObserver = MyCustomLogStrategy();
DatasourceObserverInstances.useHigherObserver = true;
```

The same applies to repositories: `RepositoryObserverInstances.useHigherObserver = true` makes your `safeCallableObserver` serve as fallback for `repositoryObserver` and `repositoryDatasourceCallableObserver`.

## 📚 API Reference

Check the full API reference, including all generic types and abstract classes, on [pub.dev → cool_bedrock](https://pub.dev/documentation/cool_bedrock/latest/).

---

# Authors & Maintainers

This project was created and is primarily maintained by:

*   **[Cayetano Bañón Rubio](https://github.com/Mithos5r)**
*   **[Coolosos](https://github.com/coolosos)**

## 🤝 Contributing

Contributions are welcome!

- Open issues for bugs or feature requests
- Fork the repo and submit a PR
- Run `dart format` and `dart test` before submitting

---

## 🧪 Testing

To run tests and see code coverage:

```bash
dart test
```

---

## 📄 License

MIT © 2025 [Coolosos](https://github.com/coolosos)

