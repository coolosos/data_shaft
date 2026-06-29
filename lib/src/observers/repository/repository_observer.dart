part of 'repository_observer_instances.dart';

/// {@template data_shaft.repository_observer}
/// Interface for monitoring the base lifecycle of a [Repository].
/// {@endtemplate}
abstract interface class RepositoryObserver implements SimpleObserver {
  const RepositoryObserver();

  @override
  void onCreate(String repositoryName);

  @override
  void onDispose(String repositoryName);
}

/// Observer for repositories that execute one-shot operations.
abstract interface class RepositoryDataSourceCallableObserver
    implements RepositoryObserver {
  const RepositoryDataSourceCallableObserver();

  /// Called just before invoking the underlying DataSource.
  ///
  /// [startTime] is the timestamp captured just before the call, useful
  /// for computing elapsed time in conjunction with [afterCall].
  void beforeCall(
    String repositoryName,
    String datasourceName, {
    required DateTime startTime,
  });

  /// Called after the DataSource finishes execution.
  ///
  /// [endTime] is the timestamp captured right after the call completes.
  /// [elapsed] is the duration computed from [startTime] to [endTime].
  void afterCall(
    String repositoryName,
    String datasourceName,
    Object? datasourceValue, {
    required DateTime endTime,
    required Duration elapsed,
  });
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
  void onInadmissibleException(
    Exception exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  });

  /// Logged when an uncontrolled server-side or infrastructure exception occurs.
  void onUnControlException(
    Exception exception,
    StackTrace stackTrace,
    String repositoryName, {
    Map<String, String>? customParameters,
  });

  /// Logged when a generic or unknown exception (Object) is caught.
  void onException(
    Object exception,
    StackTrace stackTrace,
    String repositoryName, {
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
  void start(String repositoryName, String datasourceName);
}
