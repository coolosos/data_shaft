import 'package:data_shaft/src/datasources/datasource_callable.dart';
import 'package:data_shaft/src/datasources/remote/datasource_mixin/datasource_head_remote.dart';
import 'package:data_shaft/src/datasources/remote/request_params/request_params.dart';
import 'package:data_shaft/src/datasources/remote/request_response/request_response.dart';

import '../mock_driver.dart';

final class TestHeadDataSource
    extends DatasourceHeadRemote<MockModel, MockRemoteDriver> {
  new({required super.driver});

  @override
  String get host => 'https://api.test.com';

  @override
  String get path => '/users/:id';

  @override
  Map<String, String> get pathModification => {':id': '123'};

  @override
  Set<int> get admissibleStatusCode => {200};

  @override
  Set<int> get inadmissibleStatusCode => {404};

  @override
  HeadParams generateCallRequirement({required Params params}) {
    return const HeadParams(
      urlParams: {'version': '1'},
      driverOptions: {'source': 'test_head'},
    );
  }

  @override
  MockModel transformation({
    required covariant RequestResponse<Object?> remoteResponse,
  }) {
    return MockModel.fromJson(remoteResponse.body!());
  }
}
