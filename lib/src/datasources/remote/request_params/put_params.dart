part of 'request_params.dart';

/// Parameters for **PUT** requests.
///
/// Used for full resource replacement.
base class PutParams extends RequestParams {
  const PutParams({
    super.headers,
    super.encodeBody,
    super.urlParams,
    super.driverOptions,
    super.encoding,
  });
}
