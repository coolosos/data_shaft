part of 'request_params.dart';

/// Parameters for **POST** requests.
///
/// Includes a specialized constructor for `x-www-form-urlencoded` payloads.
base class PostParams extends RequestParams {
  const PostParams({
    super.headers,
    super.encodeBody,
    super.urlParams,
    super.driverOptions,
    super.encoding,
  });

  /// Creates parameters for a request with `application/x-www-form-urlencoded` body.
  ///
  /// It automatically sets the 'content-type' header and encodes [formFields]
  /// into a URL-safe query string.
  PostParams.xWwwFormUrlencoded({
    required Map<String, String> formFields,
    super.headers = const {'content-type': 'application/x-www-form-urlencoded'},
    Encoding encoding = utf8,
    super.urlParams,
  }) : super(
          encoding: encoding,
          encodeBody: () => formFields.entries.map((field) {
            final key = Uri.encodeQueryComponent(
              field.key,
              encoding: encoding,
            );
            final value = Uri.encodeQueryComponent(
              field.value,
              encoding: encoding,
            );
            return '$key=$value';
          }).join('&'),
        );
}
