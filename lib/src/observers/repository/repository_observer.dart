part of 'repository_observer_instances.dart';

/// {@template data_shaft.repository_observer}
/// Interface for monitoring the base lifecycle of a [Repository].
/// {@endtemplate}
abstract interface class RepositoryObserver implements SimpleObserver {
  const RepositoryObserver();

  @override
  void onCreate(String name);

  @override
  void onDispose(String name);
}

/// Observer for repositories that execute one-shot operations.
abstract interface class RepositoryDataSourceCallableObserver
    implements RepositoryObserver {
  const RepositoryDataSourceCallableObserver();

  /// Called just before invoking the underlying DataSource.
  @mustCallSuper
  void beforeCall(String name, String callableName);

  /// Called after the DataSource finishes execution.
  @mustCallSuper
  void afterCall(String name, String datasourceName, Object? datasourceValue);
}

/// {@template data_shaft.safe_callable_repository_observer}
/// A specialized observer that captures exceptions during "Safe" calls.
///
/// It extends [RepositoryDataSourceCallableObserver] to add specific
/// hooks for mapping exceptions into [RepositoryError]s.
/// {@endtemplate}
abstract interface class SafeCallableRepositoryObserver
    extends RepositoryDataSourceCallableObserver {
  const SafeCallableRepositoryObserver();

  /// Logged when a known inadmissible business logic exception occurs.
  @mustCallSuper
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  });

  /// Logged when an uncontrolled server-side or infrastructure exception occurs.
  @mustCallSuper
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  });

  /// Logged when a generic or unknown exception (Object) is caught.
  @mustCallSuper
  void onException(
    Object exception,
    StackTrace stackTrace,
    String callableName, {
    Map<String, String>? customParameters,
  });
}

/// {@template data_shaft.repository_data_source_streamable_observer}
/// Interface for monitoring repositories that establish continuous data flows.
///
/// Unlike callable observers that track execution and completion, this observer
/// focuses on the connection lifecycle of a [Stream].
/// {@endtemplate}
abstract interface class RepositoryDataSourceStreamableObserver
    implements RepositoryObserver {
  const RepositoryDataSourceStreamableObserver();

  /// Called when the repository starts listening to the underlying [DataSourceStreamable].
  ///
  /// Useful for tracking active subscriptions or debugging why a stream
  /// might be re-initialized multiple times.
  @mustCallSuper
  void start(String name, String callableName);
}
