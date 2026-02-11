import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;

/// {@template data_shaft.on_exception_repository_error}
/// Error representing a **failure during the orchestration or transformation** 
/// within the Repository.
///
/// Unlike inadmissible errors, this typically occurs when the Data Source succeeds
/// but the Repository fails to process the result (e.g., an error in a `Map`
/// operation or a failure while merging multiple data sources).
/// {@endtemplate}
base class OnExceptionRepositoryError extends RepositoryError {
  /// {@macro data_shaft.on_exception_repository_error}
  const OnExceptionRepositoryError({
    super.message = 'Error during Repository orchestration',
  });

  @override
  List<Object?> get props => [message];
}
