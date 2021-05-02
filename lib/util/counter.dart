class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;

  void incrementWithValue(int v) => value += v;

  void decrementWithValue(int v) => value -= v;
}
