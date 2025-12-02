import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart'
    show RepositoryError, Either, Left;

import '../../issues/datasource_exception/inadmissible_data_source_exception.dart';
import '../../issues/datasource_exception/un_control_data_source_exception.dart';
import '../base_repository.dart';

mixin SafeRepositoryHelper<ValueType> on Repository {
  ///Unhandled status code from server
  RepositoryError Function(
    UnControlDataSourceException exception,
    StackTrace stackTrace,
  )
  get onUnControlException;

  ///Get invalid status code from server
  RepositoryError Function(
    InadmissibleDataSourceException exception,
    StackTrace stackTrace,
  )
  get onInadmissibleException;

  ///Unhandled exception
  RepositoryError Function(Object exception, StackTrace stackTrace)
  get onException;

  ///Control call exception and return some error management by failures:
  /// * onException
  /// * onInadmissibleException
  /// * onUnControlException
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
      //No esta pudiendo ser controlada la exception con lo que hay que tener cuidado
      return Left(onException(exception, stackTrace));
    }
  }
}
