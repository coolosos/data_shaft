part of 'request_params.dart';

/// Parameters for **GET** requests.
///
/// Typically excludes [encodeBody] as GET requests should not have a payload.
base class GetParams extends RequestParams {
  const GetParams({super.headers, super.urlParams, super.driverOptions});
}
