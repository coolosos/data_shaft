part of 'repository_observer_instances.dart';

abstract interface class RepositoryObserver implements SimpleObserver {
  const RepositoryObserver();

  @override
  void onCreate(String name);

  @override
  void onDispose(String name);
}

abstract interface class RepositoryDataSourceCallableObserver
    implements RepositoryObserver {
  const RepositoryDataSourceCallableObserver();
  @mustCallSuper
  void beforeCall(String name, String callableName);

  @mustCallSuper
  void afterCall(String name, String datasourceName, Object? datasourceValue);
}

abstract interface class RepositoryDataSourceStreamableObserver
    implements RepositoryObserver {
  const RepositoryDataSourceStreamableObserver();

  @mustCallSuper
  void start(String name, String callableName);
}

abstract interface class SafeCallableRepositoryObserver
    extends RepositoryDataSourceCallableObserver {
  const SafeCallableRepositoryObserver();

  @mustCallSuper
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {}

  @mustCallSuper
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {}

  @mustCallSuper
  void onException(
    Object exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  }) {}
}
