import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;

/// {@template data_shaft.inadmissible_repository_error}
/// Error representing a **controlled business failure** that originated in the [DataSource].
///
/// This error is the result of mapping an [InadmissibleDataSourceException].
/// It should be used for scenarios that are technically successful at the protocol
/// level but invalid for the domain logic (e.g., "Account locked", "Resource not found").
/// {@endtemplate}
base class InadmissibleRepositoryError extends RepositoryError {
  /// {@macro data_shaft.inadmissible_repository_error}
  const InadmissibleRepositoryError({
    super.message = 'Inadmissible result from Data Source',
  });

  @override
  List<Object?> get props => [message];
}
