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

/// {@template data_shaft.safe_repository}
/// A robust [Repository] implementation that bridges a [DataSource] with the Domain layer.
///
/// It combines [RepositoryDataSourceCallable] for execution and [SafeRepositoryHelper]
/// for error handling. It automatically catches exceptions thrown by the datasource
/// and maps them to standard [RepositoryError] types.
///
/// ### Default Behavior:
/// * **UnControlException** -> returns [UnControlRepositoryError].
/// * **InadmissibleException** -> returns [InadmissibleRepositoryError].
/// * **Other Exceptions** -> returns [OnExceptionRepositoryError].
///
/// ### Usage Example:
/// ```dart
/// class MyRepo extends SafeRepositoryDatasourceCallable<User, UserRemoteDataSource> {
///   MyRepo({required super.dataSource});
///
///   // You can override onInadmissibleException to provide custom error messages
///   @override
///   RepositoryError Function(InadmissibleDataSourceException, StackTrace)
///       get onInadmissibleException => (e, s) => MyCustomError(e.message);
/// }
/// ```
/// {@endtemplate}
abstract class SafeRepositoryDatasourceCallable<Info,
        DS extends DataSourceCallable<Info>>
    extends RepositoryDataSourceCallable<Info, DS>
    with SafeRepositoryHelper<Info> {
  /// {@macro data_shaft.safe_repository}
  SafeRepositoryDatasourceCallable({required super.dataSource});

  @override
  SafeCallableRepositoryObserver get observer =>
      RepositoryObserverInstances.safeCallableObserver;

  /// Executes the datasource call within a [safeCall] block.
  @override
  Future<Either<RepositoryError, Info>> call({
    required covariant Params repositoryParams,
  }) async {
    return safeCall(call: () => super.call(repositoryParams: repositoryParams));
  }

  /// Default handler for uncontrolled exceptions (e.g., 500 Internal Server Error).
  /// Logs the error and returns [UnControlRepositoryError].
  @override
  RepositoryError Function(
    UnControlDataSourceException exception,
    StackTrace stackTrace,
  ) get onUnControlException => (exception, stackTrace) {
        observer.onUnControlException(
          exception,
          stackTrace,
          runtimeType.toString(),
        );
        return const UnControlRepositoryError();
      };

  /// Default handler for inadmissible exceptions (e.g., 404 Not Found).
  /// Logs the error and returns [InadmissibleRepositoryError].
  @override
  RepositoryError Function(
    InadmissibleDataSourceException exception,
    StackTrace stackTrace,
  ) get onInadmissibleException => (exception, stackTrace) {
        observer.onInadmissibleException(
          exception,
          stackTrace,
          runtimeType.toString(),
        );
        return const InadmissibleRepositoryError();
      };

  /// Default handler for unexpected exceptions (e.g., parsing errors).
  /// Logs the error and returns [OnExceptionRepositoryError].
  @override
  RepositoryError Function(Object exception, StackTrace stackTrace)
      get onException => (exception, stackTrace) {
            observer.onException(exception, stackTrace, runtimeType.toString());
            return const OnExceptionRepositoryError();
          };
}
