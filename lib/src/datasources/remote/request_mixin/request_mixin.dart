import 'package:cool_bedrock/cool_bedrock.dart';
import 'package:data_shaft/src/datasources/driver/remote_driver.dart';
import 'package:data_shaft/src/datasources/remote/datasource_remote.dart';
import 'package:meta/meta.dart';

part 'delete_mixin.dart';
part 'get_mixin.dart';
part 'patch_mixin.dart';
part 'post_mixin.dart';
part 'put_mixin.dart';

/// Helper function to merge the base [uri] with specific [params].
///
/// It combines the query parameters present in the base [uri] with those provided
/// in [params.urlParams].
@protected
Uri _obtainUriWithParams(RequestParams? params, Uri uri) {
  final urlParams = params?.urlParams;

  // Logic to merge existing query params with new ones
  final queryParams =
      (uri.queryParameters.isNotEmpty || (urlParams?.isNotEmpty ?? false))
      ? {
          if (uri.queryParameters.isNotEmpty) ...uri.queryParameters,
          if (urlParams != null) ...urlParams,
        }
      : null;

  return Uri(
    host: uri.host,
    port: uri.port,
    path: uri.path,
    scheme: uri.scheme,
    queryParameters: queryParams,
  );
}
