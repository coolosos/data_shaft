import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart'
    show Either, Left, RepositoryError;

import '../../issues/datasource_exception/inadmissible_data_source_exception.dart';
import '../../issues/datasource_exception/un_control_data_source_exception.dart';
import '../base_repository.dart';

/// A mixin that provides a safety net for repository executions.
///
/// It forces the implementation of error mappers and provides the [safeCall] method
/// to wrap potentially throwing operations into a safe [Either] result.
mixin SafeRepositoryHelper<ValueType> on Repository {
  /// Maps [UnControlDataSourceException] (e.g., 500 Server Error) to a [RepositoryError].
  RepositoryError Function(
    UnControlDataSourceException exception,
    StackTrace stackTrace,
  ) get onUnControlException;

  /// Maps [InadmissibleDataSourceException] (e.g., 400 Bad Request, 404 Not Found) to a [RepositoryError].
  RepositoryError Function(
    InadmissibleDataSourceException exception,
    StackTrace stackTrace,
  ) get onInadmissibleException;

  /// Maps generic or unexpected [Object] exceptions (e.g., parsing errors) to a [RepositoryError].
  RepositoryError Function(Object exception, StackTrace stackTrace)
      get onException;

  /// Executes a function safely, catching defined exceptions and mapping them to [Left].
  ///
  /// Use this wrapper to ensure your repository never throws an exception to the domain layer.
  ///
  /// **Flow:**
  /// 1. Executes [call].
  /// 2. If successful, returns [Right] (or whatever [call] returns).
  /// 3. If [UnControlDataSourceException] is thrown -> returns [Left] via [onUnControlException].
  /// 4. If [InadmissibleDataSourceException] is thrown -> returns [Left] via [onInadmissibleException].
  /// 5. If any other [Exception] is thrown -> returns [Left] via [onException].
  FutureOr<Either<RepositoryError, ValueType>> safeCall({
    required FutureOr<Either<RepositoryError, ValueType>> Function() call,
  }) async {
    try {
      return await call();
    } on UnControlDataSourceException catch (e, s) {
      return Left(onUnControlException(e, s));
    } on InadmissibleDataSourceException catch (e, s) {
      return Left(onInadmissibleException(e, s));
    } catch (exception, stackTrace) {
      // Catch-all for unexpected errors (parsing, null pointers, etc.)
      return Left(onException(exception, stackTrace));
    }
  }
}
