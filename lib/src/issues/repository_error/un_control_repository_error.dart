import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;

/// {@template data_shaft.uncontrol_repository_error}
/// Error representing an **unanticipated failure** captured by the Repository's safety net.
///
/// This acts as a boundary guard to prevent raw exceptions (like `TypeError` or
/// `NullThrownError`) from leaking into the Domain or UI layers.
/// {@endtemplate}
base class UnControlRepositoryError extends RepositoryError {
  /// {@macro data_shaft.uncontrol_repository_error}
  const UnControlRepositoryError({
    super.message = '...',
    this.cause,
    this.stackTrace,
  });
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message];
}
