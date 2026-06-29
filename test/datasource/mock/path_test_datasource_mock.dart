import 'package:data_shaft/datasource.dart';

import 'mock_driver.dart';

final class PathTestDataSource
    extends DatasourceGetRemote<MockModel, MockRemoteDriver> {
  PathTestDataSource({
    required super.driver,
    required this.customPath,
    required this.customPrefix,
  });
  final String customPath;
  final String customPrefix;

  @override
  String get host => 'https://test.com';
  @override
  String get path => customPath;
  @override
  String? get pathPrefix => customPrefix;

  @override
  Set<int> get admissibleStatusCode => {200};
  @override
  MockModel transformation(
          {required covariant RequestResponse remoteResponse}) =>
      const MockModel(name: '');
  @override
  GetParams generateCallRequirement({required Params params}) =>
      const GetParams();
}
