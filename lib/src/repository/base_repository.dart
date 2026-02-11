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
    _repositoryObserver.onCreate(runtimeType.toString());
  }

  static final RepositoryObserver _repositoryObserver =
      RepositoryObserverInstances.repositoryObserver;

  /// Frees up resources and notifies the observer.
  ///
  /// Must be called when the repository is no longer needed (e.g., when a BLoC/Provider closes).
  @mustCallSuper
  void dispose() {
    _repositoryObserver.onDispose(runtimeType.toString());
  }
}
