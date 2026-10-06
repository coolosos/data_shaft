part of 'request_params.dart';

/// Parameters for **PATCH** requests.
///
/// Used for partial updates.
base class PatchParams extends RequestParams {
  const new({
    super.headers,
    super.encodeBody,
    super.urlParams,
    super.driverOptions,
    super.encoding,
  });
}
