import 'package:cool_bedrock/cool_bedrock.dart' show DataSourceException;

/// {@template data_shaft.uncontrol_exception}
/// Exception thrown when an **unexpected error** occurs within the [DataSource]
/// or the underlying [Driver] that is not explicitly handled or anticipated
/// by the system.
///
/// This usually signifies a programming error, a failure in a dependency,
/// or an unhandled exception during processing. This is a controlled way
/// to wrap an unexpected failure before propagating it up the stack.
///
/// **Example:** A deserialization error, a database constraint violation that
/// wasn't checked, or a timeout that wasn't properly caught by the Driver.
/// {@endtemplate}
final class UnControlDataSourceException extends DataSourceException {
  /// {@macro data_shaft.uncontrol_exception}
  const UnControlDataSourceException({
    this.body,
    this.statusCode,
    this.reasonPhrase,
    super.message,
    super.requestHeaders,
    super.requestUri,
    super.requestBody,
  });

  /// The optional response body associated with the unexpected error.
  final String? body;

  /// The optional status code associated with the unexpected error.
  final int? statusCode;

  /// A brief, human-readable reason for the error, if available (e.g., HTTP reason phrase).
  final String? reasonPhrase;

  @override
  String toString() {
    return 'UnControlException(requestUri: $requestUri, requestBody: $requestBody, requestHeaders: $requestHeaders, statusCode: $statusCode, body: $body, reasonPhrase: $reasonPhrase,)';
  }

  @override
  List<Object?> get props => [...super.props, body, statusCode, reasonPhrase];
}
