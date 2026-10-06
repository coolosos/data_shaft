import 'dart:convert';

import 'package:data_shaft/datasource.dart';
import 'package:test/test.dart';

void main() {
  group('PostParams.xWwwFormUrlencoded', () {
    test('sets the form-urlencoded content-type header by default', () {
      final params = PostParams.xWwwFormUrlencoded(formFields: {'a': '1'});

      expect(
        params.headers?['content-type'],
        'application/x-www-form-urlencoded',
      );
    });

    test('keeps a manually provided content-type header', () {
      final params = PostParams.xWwwFormUrlencoded(
        formFields: {'a': '1'},
        headers: const {
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );

      expect(
        params.headers?['content-type'],
        'application/x-www-form-urlencoded; charset=UTF-8',
      );
    });

    test('encodes form fields into a url-safe query string', () {
      final params = PostParams.xWwwFormUrlencoded(
        formFields: {'a': '1', 'b': 'two'},
      );

      expect(params.encoding, utf8);
      expect(params.encodeBody?.call(), 'a=1&b=two');
    });

    test('percent-encodes special characters with utf8', () {
      final params = PostParams.xWwwFormUrlencoded(
        formFields: {'email': 'john@example.com', 'note': 'a&b+c=d'},
      );

      expect(
        params.encodeBody?.call(),
        'email=john%40example.com&note=a%26b%2Bc%3Dd',
      );
    });

    test('uses the provided encoding for non-ascii characters', () {
      final params = PostParams.xWwwFormUrlencoded(
        formFields: {'word': 'café'},
        encoding: latin1,
      );

      expect(params.encoding, latin1);
      expect(params.encodeBody?.call(), 'word=caf%E9');
    });

    test('passes urlParams through to the base params', () {
      final params = PostParams.xWwwFormUrlencoded(
        formFields: {'a': '1'},
        urlParams: const {'token': 't'},
      );

      expect(params.urlParams, {'token': 't'});
    });
  });
}
