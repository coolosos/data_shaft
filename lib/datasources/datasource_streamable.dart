import 'dart:async';

import 'package:cool_bedrock/cool_bedrock.dart';

import 'datasource.dart';

export 'package:cool_bedrock/cool_bedrock.dart' show Params;

/// {@template data_shaft.datasource_streamable}
/// An abstract [DataSource] designed to provide a continuous **stream of data**
/// of type [T].
///
/// This class is used for Data Sources that need to push updates to the Repository
/// layer as data changes over time (e.g., real-time database updates,
/// persistent subscription handlers, or watching local storage).
///
/// It forms the basis for observable data patterns in the Clean Architecture.
///
/// - [T]: The type of data items emitted by the stream.
/// {@endtemplate}
abstract class DataSourceStreamable<T> extends DataSource {
  /// {@macro data_shaft.datasource_streamable}
  DataSourceStreamable();

  /// Returns a [Stream] that emits data of type [T] whenever the underlying
  /// data source changes.
  ///
  /// The [params] define the criteria or identifier necessary to initiate
  /// and maintain the subscription (e.g., a unique user ID, a document path).
  ///
  /// The use of the **`covariant`** keyword allows concrete implementations
  /// to use a more specific type for [params] than what is defined by the
  /// abstract base class that defines [Params] (if one exists).
  ///
  /// - [params]: The required input parameters for the stream subscription.
  /// - Returns: A [Stream] of [T] data events.
  Stream<T> stream({required covariant Params params});
}
