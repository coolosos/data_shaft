part of 'datasource_observer_instances.dart';

final class _SimpleDatasourceObserverImpl implements SimpleDatasourceObserver {
  @override
  void onCreate(String name) {
    log('⛅️ Datasource $name create');
  }

  @override
  void onDispose(String name) {
    log('💨 Datasource $name dispose');
  }
}
