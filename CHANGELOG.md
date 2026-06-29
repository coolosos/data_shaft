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