import 'dart:async';
import 'package:data_shaft/src/datasources/datasource_callable.dart';

class User {
  User({required this.id, required this.name});
  final String id;
  final String name;
}

final class UserParams extends Params {
  const UserParams({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];

  @override
  bool get isValid => id.isNotEmpty;
}

class UserDataSourceMock extends DataSourceCallable<User> {
  int callCount = 0;
  Duration delay = Duration.zero;

  @override
  Future<User> call({required Params params}) async {
    callCount++;
    await Future.delayed(delay);
    if (params is UserParams) {
      return User(id: params.id, name: 'User ${params.id}');
    }
    throw UnimplementedError();
  }
}

class UserDataSourceThrowMock extends DataSourceCallable<User> {
  int callCount = 0;
  Exception? errorToThrow;
  Duration delay = Duration.zero;

  @override
  Future<User> call({required Params params}) async {
    callCount++;
    await Future.delayed(delay);
    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    if (params is UserParams) {
      return User(id: params.id, name: 'User ${params.id}');
    }
    throw UnimplementedError();
  }
}
