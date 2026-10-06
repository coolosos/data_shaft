part of 'request_params.dart';

/// Parameters for **HEAD** requests.
///
/// Semantically identical to [GetParams]: the server must not return a
/// response body, so no [encodeBody] is exposed. Useful for retrieving
/// headers (e.g. checking resource existence or an `ETag`).
base class HeadParams extends RequestParams {
  const new({super.headers, super.urlParams, super.driverOptions});
}
