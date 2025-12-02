part of 'repository_observer_instances.dart';

class _DefaultRepositoryImp implements RepositoryDataSourceCallableObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Repository $name create');
  }

  @override
  void onDispose(String name) {
    log('💨 Repository $name dispose');
  }

  @override
  void afterCall(String name, String datasourceName, Object? datasourceValue) {
    log('💨 Repository $name call $datasourceName with value $datasourceValue');
  }

  @override
  void beforeCall(String name, String datasourceName) {
    log('💨 Repository $name are going to call $datasourceName');
  }
}

@reopen
class _DefaultSafeRepository extends SafeCallableRepositoryObserver {
  @override
  void afterCall(String name, String datasourceName, Object? datasourceValue) {
    log('💨 Repository $name call $datasourceName with value $datasourceValue');
  }

  @override
  void beforeCall(String name, String callableName) {
    log('💨 Repository $name are going to call $callableName');
  }

  @override
  void onCreate(String name) {
    log('⛅️ Repository $name create');
  }

  @override
  void onDispose(String name) {
    log('💨 Repository $name dispose');
  }
}

class _DefaultRepositoryDataSourceStreamableObserverImpl
    implements RepositoryDataSourceStreamableObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Repository $name create');
  }

  @override
  void onDispose(String name) {
    log('💨 Repository $name dispose');
  }

  @override
  void start(String name, String callableName) {
    log('💨 Repository $name are going to call $callableName');
  }
}
