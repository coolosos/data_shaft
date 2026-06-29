import 'package:meta/meta.dart';

import '../observers/repository/repository_observer_instances.dart';

/// {@template data_shaft.repository}
/// The base abstract class for all Repositories in the architecture.
///
/// It handles the lifecycle observation logic, automatically notifying the
/// [RepositoryObserver] upon creation and disposal.
///
/// **Lifecycle:**
/// * **Construction**: Triggers `observer.onCreate`.
/// * **Disposal**: Triggers `observer.onDispose`.
/// {@endtemplate}
abstract class Repository {
  /// {@macro data_shaft.repository}
  Repository() {
    RepositoryObserverInstances.repositoryObserver.onCreate(
      runtimeType.toString(),
    );
  }

  /// Frees up resources and notifies the observer.
  ///
  /// Must be called when the repository is no longer needed (e.g., when a BLoC/Provider closes).
  @mustCallSuper
  void dispose() {
    RepositoryObserverInstances.repositoryObserver.onDispose(
      runtimeType.toString(),
    );
  }
}
