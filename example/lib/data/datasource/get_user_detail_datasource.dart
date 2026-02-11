import 'package:data_shaft/datasource.dart';
import 'package:data_shaft_example/data/datasource/remote/remote_user.dart';
import 'package:data_shaft_example/data/http_client/client.dart';

export 'package:data_shaft_example/data/datasource/remote/remote_user.dart';

final class GetUserDetailDatasource
    extends DatasourceGetRemote<RemoteUser, HttpDriver> {
  GetUserDetailDatasource({required super.driver});

  int count = 0;
  Exception? throwException;

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
  GetParams generateCallRequirement({required Params params}) {
    return const GetParams(urlParams: {'version': '1'});
  }

  @override
  Future<RemoteUser> call({required Params params}) {
    count++;
    if (throwException case final exception?) {
      throw exception;
    }
    return super.call(params: params);
  }

  @override
  RemoteUser transformation({required RequestResponse remoteResponse}) {
    return RemoteUser.fromJson(remoteResponse.body!);
  }
}
