import 'package:data_shaft/datasource.dart';

import '../mock_driver.dart';

final class TestPutDataSource
    extends DatasourcePutRemote<MockModel, MockRemoteDriver> {
  TestPutDataSource({required super.driver});

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
  PutParams generateCallRequirement({required Params params}) {
    return const PutParams(urlParams: {'version': '1'});
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
