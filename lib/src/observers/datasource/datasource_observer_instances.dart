library;

import 'dart:developer';

import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:meta/meta.dart';

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
class DatasourceObserverInstances {
  static SimpleDatasourceObserver? _datasourceObserver;
  static HttpDatasourceObserver? _httpDatasourceObserver;

  /// Sets a custom observer for basic Data Source lifecycle events.
  static set datasourceObserver(SimpleDatasourceObserver observer) =>
      _datasourceObserver = observer;

  /// Sets a custom observer for HTTP remote events.
  static set httpDatasourceObserver(HttpDatasourceObserver observer) =>
      _httpDatasourceObserver = observer;

  /// Returns the current simple observer or a default developer log implementation.
  static SimpleDatasourceObserver get datasourceObserver =>
      _datasourceObserver ?? _SimpleDatasourceObserverImpl();

  /// Returns the current HTTP observer or a default developer log implementation.
  static HttpDatasourceObserver get httpDatasourceObserver =>
      _httpDatasourceObserver ?? _HttpDatasourceObserverImpl();
}
