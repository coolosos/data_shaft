import 'package:data_shaft/repository.dart';
import 'package:test/test.dart';

class _DedupProbe with DeduplicationExecution<int> {
  int executions = 0;
  bool shouldThrow = false;

  Future<int> run() => deduplicationExecution(() async {
    executions++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (shouldThrow) {
      throw StateError('boom');
    }
    return 42;
  });
}

void main() {
  group('DeduplicationExecution', () {
    test('deduplicates concurrent executions into a single call', () async {
      final probe = _DedupProbe();

      final results = await Future.wait([
        probe.run(),
        probe.run(),
        probe.run(),
      ]);

      expect(probe.executions, 1);
      expect(results, [42, 42, 42]);
    });

    test('waiters share the same error and the state resets', () async {
      final probe = _DedupProbe()..shouldThrow = true;

      final results = await Future.wait([
        probe.run().then((_) => 'ok', onError: (_) => 'error'),
        probe.run().then((_) => 'ok', onError: (_) => 'error'),
      ]);

      expect(probe.executions, 1);
      expect(results, ['error', 'error']);

      probe.shouldThrow = false;
      final value = await probe.run();

      expect(value, 42);
      expect(
        probe.executions,
        2,
        reason: 'a new run starts fresh after the error',
      );
    });
  });
}
