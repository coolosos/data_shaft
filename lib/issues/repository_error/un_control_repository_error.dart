import 'package:cool_bedrock/cool_bedrock.dart' show RepositoryError;

/// {@template data_shaft.uncontrol_repository_error}
/// Error thrown by the Repository when a **catch-all block** (e.g., `catch (e)`)
/// captures an exception that was not explicitly anticipated or handled
/// by the Repository or Data Source layers.
///
/// This error signifies an unexpected internal problem (like a Null Pointer
/// or a configuration error) and serves as the safety net to prevent raw
/// exceptions from escaping the Data Layer boundary.
/// {@endtemplate}
base class UnControlRepositoryError extends RepositoryError {
  /// {@macro data_shaft.uncontrol_repository_error}
  const UnControlRepositoryError({this.message = 'On UnControl Repository'});

  @override
  final String message;

  @override
  List<Object?> get props => [message];
}
