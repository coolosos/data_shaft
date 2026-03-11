import 'package:data_shaft/datasource.dart';

import '../mock_driver.dart';

final class TestDeleteDataSource
    extends DatasourceDeleteRemote<MockModel, MockRemoteDriver> {
  TestDeleteDataSource({required super.driver});

  int callCount = 0;

  @override
  String get host => 'https://api.test.com';

  @override
  String get path => '/users/:id';

  @override
  Map<String, String> get pathModification => {':id': '123'};

  @override
  List<int> get admissibleStatusCode => [200];

  @override
  List<int> get inadmissibleStatusCode => [404];

  @override
  DeleteParams generateCallRequirement({required Params params}) {
    return const DeleteParams(urlParams: {'version': '1'});
  }

  @override
  Future<MockModel> call({required covariant Params params}) {
    callCount++;
    return super.call(params: params);
  }

  @override
  MockModel transformation({required RequestResponse remoteResponse}) {
    return MockModel.fromJson(remoteResponse.body!.call());
  }
}
