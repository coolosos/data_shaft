import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart';

import 'datasource.dart';

export 'package:cool_bedrock/cool_bedrock.dart' show Params;

/// {@template data_shaft.datasource_callable}
/// An abstract [DataSource] designed to represent a **single, callable operation**.
///
/// This class is ideal for Data Sources that encapsulate a specific, non-streaming
/// request, such as:
///
/// * Fetching a single user by ID.
/// * Sending a registration request.
/// * Saving a configuration setting.
///
///
/// [ValueType] represents the type of data returned by the operation.
/// {@endtemplate}
abstract class DataSourceCallable<ValueType> extends DataSource {
  /// {@macro data_shaft.datasource_callable}
  DataSourceCallable();

  /// Executes the specific data operation defined by this source.
  ///
  /// The [call] method allows the Repository to invoke the Data Source instance
  /// directly as a function (e.g., `await remoteDataSource(params: userId)`).
  ///
  /// - [params]: The required input parameters for this specific operation.
  /// - Returns: A [FutureOr] of [ValueType], which is the result of the operation.
  FutureOr<ValueType> call({required covariant Params params});
}
