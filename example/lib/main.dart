// ignore_for_file: avoid_print

import 'package:data_shaft/data_shaft.dart';
import 'package:data_shaft_example/data/datasource/get_user_detail_datasource.dart';
import 'package:data_shaft_example/data/http_client/client.dart';
import 'package:data_shaft_example/data/repository/get_user_cache_detail_repository.dart';
import 'package:data_shaft_example/data/repository/get_user_detail_repository.dart';

Future<void> main(List<String> args) async {
  final successfulDriver = HttpDriver(
    simulatedResponse: const RequestResponse(
      statusCode: 200,
      body: '{"name": "Dart User"}',
    ),
  );

  final successfulDatasource =
      GetUserDetailDatasource(driver: successfulDriver);
  final successfulRepository =
      GetUserDetailRepository(dataSource: successfulDatasource);

  print('\n--- Successful request set ---');

  final successfulResult =
      await successfulRepository.call(repositoryParams: noParams);

  print('Result: $successfulResult');
  // Output: Right(User(name: Dart User))

  print('\n--- Multiple(8) requests at same time ---');

  successfulDatasource.count = 0; // Reset counter for demo

  final requests = List.generate(
    8,
    (_) => successfulRepository.call(repositoryParams: noParams),
  );

  await Future.wait(requests);

  print('Number of datasource calls: ${successfulDatasource.count}');
  print('Result: Deduplication repository prevented multiple API calls.');
  // Output expected: 1 call

  print('\n--- Throw/Error request set ---');

  final throwDriver = HttpDriver(
    simulatedResponse: const RequestResponse(statusCode: 404),
  );

  final throwDatasource = GetUserDetailDatasource(driver: throwDriver)
    ..throwException = const UnControlDataSourceException();

  final throwRepository = GetUserDetailRepository(dataSource: throwDatasource);

  final errorResult = await throwRepository.call(repositoryParams: noParams);

  print('Is result a Failure? ${errorResult.isLeft()}');
  print('Result content: $errorResult');
  print('Note: Being a Safe repository prevents exceptions bubbling up.');

  print('\n--- Cache request set ---');

  final cacheRepository =
      GetUserCacheDetailRepository(dataSource: successfulDatasource);
  successfulDatasource.count = 0;

  await cacheRepository.call(repositoryParams: noParams);

  await Future.delayed(const Duration(seconds: 1));

  await cacheRepository.call(repositoryParams: noParams);

  print(
    'Datasource calls after 2 repository calls (within TTL): ${successfulDatasource.count}',
  );
  // Output expected: 1

  print('Waiting for cache expiration...');
  await Future.delayed(const Duration(milliseconds: 1010));

  await cacheRepository.call(repositoryParams: noParams);

  print(
    'Datasource calls after cache expiration: ${successfulDatasource.count}',
  );
  // Output expected: 2
}
