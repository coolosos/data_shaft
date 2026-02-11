part of 'request_params.dart';

/// Parameters for **DELETE** requests.
///
/// Although uncommon, it supports [encodeBody] for APIs that require
/// a payload during deletion.
base class DeleteParams extends RequestParams {
  const DeleteParams({
    super.headers,
    super.urlParams,
    super.encodeBody,
    super.driverOptions,
    super.encoding,
  });
}
