## 1.0.2 - 2026-4-10
### Added
- Remote datasource request function for unify observer and logic

## 1.0.1 - 2026-4-10
### Fix
- Datasource drive now request the generic

## 1.0.0 - 2026-2-11
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