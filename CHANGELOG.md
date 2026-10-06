## 3.0.0
### ⚠️ BREAKING CHANGES
- **Minimum SDK raised to Dart 3.13**: `environment.sdk` is now `">=3.13.0 <4.0.0"`.
- **`cool_bedrock` bumped to `^3.0.0`**: the new major version of the underlying dependency.
### Added
- **HEAD request support**: `HeadParams`, `HeadCall` mixin and `DatasourceHeadRemote` for remote HEAD operations.
- **`RepositoryCallErrorObserver`**: new `callErrorObserver` slot in `RepositoryObserverInstances` to observe datasource call errors together with timing info (`endTime`, `elapsed`).
- **Error context**: `UnControlRepositoryError` now exposes `cause` and `stackTrace`; `InadmissibleRepositoryError` exposes `statusCode` and `body`. Default mappers propagate this context automatically.
### Fixed
- **Caching semantics clarified**: `refreshCache` is now invoked on every outcome (success and failure) and acts as the extension point for custom caching policies. By default a failed call returns `null`, which **clears** the cache, so the next call always re-queries the datasource. Override it (e.g. `datasourceResponse.toNullable() ?? cache`) to keep the last valid value on failure.
- **No deadlock on deduplication**: the dedup key is now always released when the underlying datasource call throws.
- **Driver options forwarding**: `encoding` and `driverOptions` are now forwarded to the driver in all HTTP methods (GET, HEAD, POST, PUT, PATCH, DELETE).
- **Lazy error body**: the `body()` callback is only evaluated on error branches in `checkInformation`.
- **`pathModification`**: now replaces every occurrence of the token instead of only the first one.
### Chore
- Aligned with Dart 3.13 lints (coolint 3.0.0), removed redundant self imports, and improved README and API documentation.

## 2.0.0
### ⚠️ BREAKING CHANGES
- **`List<int>` → `Set<int>` for status codes**: `inadmissibleStatusCode` and `admissibleStatusCode` in `DatasourceRemote` and observer interfaces now return `Set<int>` instead of `List<int>`.
    * **Impact**: Existing observer implementations that use `List<int>` as parameter types must update to `Set<int>`.
    * **Reasoning**: `Set<int>` better represents unique status codes and eliminates unnecessary `List.from()` allocations.
- **Observer naming & timing**: Repository observer methods deprecated `name` → `repositoryName`, `callableName` → `datasourceName`; `beforeCall` now receives `startTime`, `afterCall` receives `endTime` and `elapsed`.
- **`@mustCallSuper` removed**: Removed from all abstract interface methods (no effect on pure interfaces).
### Added
- `useHigherObserver` flag in `DatasourceObserverInstances` and `RepositoryObserverInstances` to enable fallback chains.
- `Set.unmodifiable()` wrapping around status codes passed to observer methods (prevents mutation).
- `reset()` method on both observer registries for test isolation.

## 1.1.3
### Added
- Datasource Remote covariant in transform and checkInformation for improve modifications

## 1.1.2
### Dependencies
- Cool_bedrock breaking change dependence

## 1.1.1
### Added
- RequestResponse now have a generic for originalResponse field

## 1.1.0
### ⚠️ BREAKING CHANGES
- **Observer Hierarchy Refactor**: `HttpDatasourceObserver` now implements `SimpleDatasourceObserver` instead of `SimpleObserver`.
    * **Impact**: It is no longer necessary to implement two observers if you want the same information in common methods such as onCreate and onDispose.
    * **Reasoning**: This change enables `DatasourceObserverInstances` to use the HTTP observer as a fallback for basic lifecycle events, reducing boilerplate configuration for users.
### Fix
- Correct use of observer in `DatasourceRemote`. The default debugPrint for datasource creation will no longer appear.

## 1.0.1
### Fix
- Datasource drive now request the generic

## 1.0.0
- Initial version.
### Added
- Datasource abstract
    - Datasource callable abstract
    - Datasource local abstract
    - Datasource streamable abstract
    - Datasource remote abstract
        - Request response
        - Request params
        - Request mixin
        - Datasource Delete Remote
        - Datasource Get Remote
        - Datasource Patch Remote
        - Datasource Post Remote
        - Datasource Put Remote
    - Drivers
- Issues
    - Datasource exception
    - Repository errors
- Observer
    - Observer singleton instance
    - Repository observer
    - Datasource observer
- Repository
    - Repository
    - Repository with datasource
        - Safe repository
        - Memory cache
        - Deduplication
        - Deduplication safe cache
    - Memory repository helper
    - Deduplication repository helper
    - Safe caller repository helper
### Chore
- Test
- Documentation