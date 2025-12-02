import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;

/// {@template data_shaft.on_exception_repository_error}
/// Error thrown by the Repository when a **specific, expected exception** occurs
/// during the orchestration or mapping logic within the Repository itself.
///
/// This error is typically used to wrap failures that are known to occur but
/// should not propagate as raw Dart exceptions outside the Data Layer (e.g.,
/// a specific mapping error or a failure to combine results from multiple sources).
/// {@endtemplate}
base class OnExceptionRepositoryError extends RepositoryError {
  /// {@macro data_shaft.on_exception_repository_error}
  const OnExceptionRepositoryError({this.message = 'On Exception Repository'});

  @override
  final String message;

  @override
  List<Object?> get props => [message];
}
