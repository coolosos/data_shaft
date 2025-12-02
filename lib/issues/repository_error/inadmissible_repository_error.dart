import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;

/// {@template data_shaft.inadmissible_repository_error}
/// Error thrown by the Repository when a DataSource returns an **inadmissible**
/// result, as defined by InadmissibleDataSourceException.
///
/// This error signifies a recognized and expected business failure condition
/// (e.g., "User Not Found," "Invalid Credentials") that originated from the
/// Data Layer and is being mapped into a structured Repository error.
/// {@endtemplate}
base class InadmissibleRepositoryError extends RepositoryError {
  /// {@macro data_shaft.inadmissible_repository_error}
  const InadmissibleRepositoryError({
    this.message = 'On Inadmissible Repository',
  });

  @override
  final String message;
  @override
  List<Object?> get props => [message];
}
