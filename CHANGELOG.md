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