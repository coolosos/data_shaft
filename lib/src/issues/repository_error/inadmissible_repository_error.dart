import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;
import 'package:data_shaft/data_shaft.dart'
    show DataSource, InadmissibleDataSourceException;

/// {@template data_shaft.inadmissible_repository_error}
/// Error representing a **controlled business failure** that originated in the [DataSource].
///
/// This error is the result of mapping an [InadmissibleDataSourceException].
/// It should be used for scenarios that are technically successful at the protocol
/// level but invalid for the domain logic (e.g., "Account locked", "Resource not found").
/// {@endtemplate}
base class InadmissibleRepositoryError extends RepositoryError {
  /// {@macro data_shaft.inadmissible_repository_error}
  const new({
    super.message = 'Inadmissible result from Data Source',
    this.statusCode,
    this.body,
  });

  /// The status code returned by the source (e.g., 404, 400), when available.
  final int? statusCode;

  /// The response body (payload) returned by the source, when available.
  final Object? body;

  @override
  List<Object?> get props => [message, statusCode, body];
}
