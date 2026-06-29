import 'package:data_shaft/src/datasources/datasource_callable.dart';
import 'package:data_shaft/src/datasources/remote/datasource_mixin/datasource_get_remote.dart';
import 'package:data_shaft/src/datasources/remote/request_params/request_params.dart';
import 'package:data_shaft/src/datasources/remote/request_response/request_response.dart';

import '../mock_driver.dart';

final class TestGetDataSource
    extends DatasourceGetRemote<MockModel, MockRemoteDriver> {
  TestGetDataSource({required super.driver});

  int callCount = 0;

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
  GetParams generateCallRequirement({required Params params}) {
    return const GetParams(urlParams: {'version': '1'});
  }

  @override
  Future<MockModel> call({required covariant Params params}) {
    callCount++;
    return super.call(params: params);
  }

  @override
  MockModel transformation(
      {required covariant RequestResponse remoteResponse}) {
    return MockModel.fromJson(remoteResponse.body!());
  }
}
