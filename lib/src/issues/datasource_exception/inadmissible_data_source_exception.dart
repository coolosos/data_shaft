import 'package:cool_bedrock/cool_bedrock.dart' show DataSourceException;

/// {@template data_shaft.inadmissible_exception}
/// Exception thrown when a DataSource returns a response that is **technically
/// successful or expected** by the underlying protocol (e.g., HTTP 404, 400),
/// but is considered **inadmissible** for the specific operation's business logic.
///
/// This exception allows the Repository layer to handle specific known failure
/// states (like "User Not Found") cleanly, often by mapping them to Domain-level
/// issues.
///
/// **Example:** Receiving an HTTP 404 response when fetching a resource by ID.
/// The 404 is an expected network code, but an inadmissible result for the business rule.
/// {@endtemplate}
final class InadmissibleDataSourceException extends DataSourceException {
  /// {@macro data_shaft.inadmissible_exception}
  const InadmissibleDataSourceException({
    required this.body,
    required this.statusCode,
    super.requestHeaders,
    super.requestUri,
    super.requestBody,
    super.message,
  });

  /// The response body (payload) returned by the source (e.g., JSON error message).
  final String body;

  /// The status code returned by the source (e.g., 404, 400).
  final int statusCode;

  @override
  String toString() {
    return 'InadmissibleException(requestUri: $requestUri, requestBody: $requestBody, requestHeaders: $requestHeaders, statusCode: $statusCode, body: $body,)';
  }

  @override
  List<Object?> get props => [...super.props, body, statusCode];
}
