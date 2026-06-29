part of 'repository_observer_instances.dart';

String _repoTag(String name) => 'REPO.$name';

class _DefaultRepositoryImp implements RepositoryDataSourceCallableObserver {
  @override
  void onCreate(String repositoryName) {
    log('⛅️ Created', name: _repoTag(repositoryName));
  }

  @override
  void onDispose(String repositoryName) {
    log('💨 Disposed', name: _repoTag(repositoryName));
  }

  @override
  void beforeCall(
    String repositoryName,
    String datasourceName, {
    required DateTime startTime,
  }) {
    log('🔛 Calling DataSource: $datasourceName',
        name: _repoTag(repositoryName));
  }

  @override
  void afterCall(
    String repositoryName,
    String datasourceName,
    Object? datasourceValue, {
    required DateTime endTime,
    required Duration elapsed,
  }) {
    log(
      '✅ Finished $datasourceName | Result: $datasourceValue | Elapsed: ${elapsed.inMilliseconds}ms',
      name: _repoTag(repositoryName),
    );
  }
}

@reopen
class _DefaultSafeRepository extends SafeCallableRepositoryObserver {
  @override
  void onCreate(String repositoryName) {
    log('⛅️ Created (Safe)', name: _repoTag(repositoryName));
  }

  @override
  void onDispose(String repositoryName) {
    log('💨 Disposed (Safe)', name: _repoTag(repositoryName));
  }

  @override
  void beforeCall(
    String repositoryName,
    String datasourceName, {
    required DateTime startTime,
  }) {
    log(
      '🔛 Starting Safe Call -> $datasourceName',
      name: _repoTag(repositoryName),
    );
  }

  @override
  void afterCall(
    String repositoryName,
    String datasourceName,
    Object? datasourceValue, {
    required DateTime endTime,
    required Duration elapsed,
  }) {
    log(
      '✅ Safe Call Complete | Result: $datasourceValue | Elapsed: ${elapsed.inMilliseconds}ms',
      name: _repoTag(repositoryName),
    );
  }

  @override
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  }) {
    log(
      '⚠️ Inadmissible Exception in $repositoryName',
      name: _repoTag('SAFE_ERROR'),
      error: exception,
    );
  }

  @override
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  }) {
    log(
      '🚨 Uncontrolled Exception in $repositoryName',
      name: _repoTag('SAFE_ERROR'),
      error: exception,
      stackTrace: stackTrace,
    );
  }

  @override
  void onException(
    Object exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  }) {
    log(
      '❌ Unexpected Object Exception in $repositoryName',
      name: _repoTag('SAFE_ERROR'),
      error: exception,
      stackTrace: stackTrace,
    );
  }
}

class _DefaultRepositoryDataSourceStreamableObserverImpl
    implements RepositoryDataSourceStreamableObserver {
  @override
  void onCreate(String repositoryName) {
    log('⛅️ Created (Streamable)', name: _repoTag(repositoryName));
  }

  @override
  void onDispose(String repositoryName) {
    log('💨 Disposed (Streamable)', name: _repoTag(repositoryName));
  }

  @override
  void start(String repositoryName, String datasourceName) {
    log(
      '📡 Starting Stream -> $datasourceName',
      name: _repoTag(repositoryName),
    );
  }
}
