library;

import 'dart:developer';

import 'package:cool_bedrock/cool_bedrock.dart';

part 'datasource_observer_implementation.dart';
part 'simple_datasource_observer.dart';

class DatasourceObserverInstances {
  static SimpleDatasourceObserver? _datasourceObserver;

  static set datasourceObserver(SimpleDatasourceObserver observer) =>
      _datasourceObserver = observer;

  static SimpleDatasourceObserver get datasourceObserver =>
      _datasourceObserver ?? _SimpleDatasourceObserverImpl();
}
