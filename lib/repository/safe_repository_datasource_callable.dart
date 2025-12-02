import 'package:cool_bedrock/cool_bedrock.dart';

import '../datasources/datasource_callable.dart';
import '../issues/datasource_exception/inadmissible_data_source_exception.dart';
import '../issues/datasource_exception/un_control_data_source_exception.dart';
import '../issues/repository_error/inadmissible_repository_error.dart';
import '../issues/repository_error/on_exception_repository_error.dart';
import '../issues/repository_error/un_control_repository_error.dart';
import '../observers/repository/repository_observer_instances.dart';
import 'helpers/safe_repository_helper.dart';
import 'repository_datasource_callable.dart';

abstract class SafeRepositoryDatasourceCallable<
  Info,
  DS extends DataSourceCallable<Info>
>
    extends RepositoryDataSourceCallable<Info, DS>
    with SafeRepositoryHelper<Info> {
  SafeRepositoryDatasourceCallable({required super.dataSource});

  @override
  SafeCallableRepositoryObserver get observer =>
      RepositoryObserverInstances.safeCallableObserver;

  @override
  Future<Either<RepositoryError, Info>> call({
    required covariant Params repositoryParams,
  }) async {
    return safeCall(call: () => super.call(repositoryParams: repositoryParams));
  }

  @override
  RepositoryError Function(
    UnControlDataSourceException exception,
    StackTrace stackTrace,
  )
  get onUnControlException => (exception, stackTrace) {
    observer.onUnControlException(
      exception,
      stackTrace,
      runtimeType.toString(),
    );
    return const UnControlRepositoryError();
  };

  @override
  RepositoryError Function(
    InadmissibleDataSourceException exception,
    StackTrace stackTrace,
  )
  get onInadmissibleException => (exception, stackTrace) {
    observer.onInadmissibleException(
      exception,
      stackTrace,
      runtimeType.toString(),
    );
    return const InadmissibleRepositoryError();
  };

  @override
  RepositoryError Function(Object exception, StackTrace stackTrace)
  get onException => (exception, stackTrace) {
    observer.onException(exception, stackTrace, runtimeType.toString());
    return const OnExceptionRepositoryError();
  };
}
