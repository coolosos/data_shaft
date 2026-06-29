library;

import 'dart:developer';

import 'package:cool_bedrock/cool_bedrock.dart';

part 'datasource_observer_implementation.dart';
part 'simple_datasource_observer.dart';
part 'http_datasource_observer.dart';

/// Static registry for Data Source observers.
///
/// By default, **Data Shaft** provides implementations that log to the console
/// using `dart:developer`. You can replace them with your own implementations:
///
/// ```dart
/// DatasourceObserverInstances.httpDatasourceObserver = MyCustomSentryObserver();
/// ```
///
/// If you only set a higher-level observer (e.g. [httpDatasourceObserver]) and want
/// it to also serve as the basic [datasourceObserver] for lifecycle events, enable
/// [useHigherObserver]:
///
/// ```dart
/// DatasourceObserverInstances.httpDatasourceObserver = MyCustomSentryObserver();
/// DatasourceObserverInstances.useHigherObserver = true;
/// ```
class DatasourceObserverInstances {
  static SimpleDatasourceObserver? _datasourceObserver;
  static HttpDatasourceObserver? _httpDatasourceObserver;

  /// When enabled, if no explicit [datasourceObserver] is set, the
  /// [httpDatasourceObserver] is used as fallback for lifecycle events
  /// ([onCreate], [onDispose]).
  static bool useHigherObserver = false;

  /// Sets a custom observer for basic Data Source lifecycle events.
  static set datasourceObserver(SimpleDatasourceObserver observer) =>
      _datasourceObserver = observer;

  /// Sets a custom observer for HTTP remote events.
  static set httpDatasourceObserver(HttpDatasourceObserver observer) =>
      _httpDatasourceObserver = observer;

  /// Returns the current simple observer or a default developer log implementation.
  ///
  /// If [useHigherObserver] is enabled and no explicit [datasourceObserver] is set,
  /// the [httpDatasourceObserver] is used as fallback.
  static SimpleDatasourceObserver get datasourceObserver =>
      _datasourceObserver ??
      (useHigherObserver ? _httpDatasourceObserver : null) ??
      _SimpleDatasourceObserverImpl();

  /// Returns the current HTTP observer or a default developer log implementation.
  static HttpDatasourceObserver get httpDatasourceObserver =>
      _httpDatasourceObserver ?? _HttpDatasourceObserverImpl();

  /// Resets all observers and flags to their default state.
  /// Useful for testing isolation.
  static void reset() {
    _datasourceObserver = null;
    _httpDatasourceObserver = null;
    useHigherObserver = false;
  }
}
