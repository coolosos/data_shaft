import 'dart:convert';

import 'package:data_shaft/data_shaft.dart';

class RemoteUser extends Codable<String, RemoteUser> {
  const RemoteUser({required this.name});

  factory RemoteUser.fromJson(String body) {
    final map = json.decode(body) as Map<String, dynamic>;
    return RemoteUser(name: map['name'] as String);
  }
  final String name;

  RemoteUser copyWith({String? name}) => RemoteUser(name: name ?? this.name);

  Map<String, dynamic> toJson() => {'name': name};

  @override
  RemoteUser decode(String remote) {
    return RemoteUser.fromJson(remote);
  }

  @override
  List<Object?> get props => [name];

  @override
  JsonCodec? get serializer => null;

  @override
  Encoding? get stringEncoding => null;
}
