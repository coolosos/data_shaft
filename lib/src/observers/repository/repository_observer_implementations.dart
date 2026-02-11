part of 'repository_observer_instances.dart';

String _repoTag(String name) => 'REPO.$name';

class _DefaultRepositoryImp implements RepositoryDataSourceCallableObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Created', name: _repoTag(name));
  }

  @override
  void onDispose(String name) {
    log('💨 Disposed', name: _repoTag(name));
  }

  @override
  void beforeCall(String name, String datasourceName) {
    log('🔛 Calling DataSource: $datasourceName', name: _repoTag(name));
  }

  @override
  void afterCall(String name, String datasourceName, Object? datasourceValue) {
    log(
      '✅ Finished $datasourceName | Result: $datasourceValue',
      name: _repoTag(name),
    );
  }
}

@reopen
class _DefaultSafeRepository extends SafeCallableRepositoryObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Created (Safe)', name: _repoTag(name));
  }

  @override
  void onDispose(String name) {
    log('💨 Disposed (Safe)', name: _repoTag(name));
  }

  @override
  void beforeCall(String name, String callableName) {
    log('🔛 Starting Safe Call -> $callableName', name: _repoTag(name));
  }

  @override
  void afterCall(String name, String datasourceName, Object? datasourceValue) {
    log(
      '✅ Safe Call Complete | Result: $datasourceValue',
      name: _repoTag(name),
    );
  }

  @override
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {
    log(
      '⚠️ Inadmissible Exception in $callableName',
      name: _repoTag('SAFE_ERROR'),
      error: exception,
    );
  }

  @override
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {
    log(
      '🚨 Uncontrolled Exception in $callableName',
      name: _repoTag('SAFE_ERROR'),
      error: exception,
      stackTrace: stackTrace,
    );
  }

  @override
  void onException(
    Object exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {
    log(
      '❌ Unexpected Object Exception in $callableName',
      name: _repoTag('SAFE_ERROR'),
      error: exception,
      stackTrace: stackTrace,
    );
  }
}

class _DefaultRepositoryDataSourceStreamableObserverImpl
    implements RepositoryDataSourceStreamableObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Created (Streamable)', name: _repoTag(name));
  }

  @override
  void onDispose(String name) {
    log('💨 Disposed (Streamable)', name: _repoTag(name));
  }

  @override
  void start(String name, String callableName) {
    log('📡 Starting Stream -> $callableName', name: _repoTag(name));
  }
}
