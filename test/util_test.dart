import 'package:fyp_yzj/util/counter.dart';
import 'package:test/test.dart';

void main() {
  group("Util tools", () {
    test('counter value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('counter value should increse by 1', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });
    test('counter value should increse by the value we want', () {
      final counter = Counter();

      counter.incrementWithValue(3);

      expect(counter.value, 3);
    });
    test('counter value should decrese by 1', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });

    test('counter value should decrese by the value we want', () {
      final counter = Counter();

      counter.decrementWithValue(3);

      expect(counter.value, -3);
    });
  });
}
