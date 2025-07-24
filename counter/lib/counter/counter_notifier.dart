// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterNotifierProvider = AutoDisposeNotifierProvider(CounterNotifier.new);

class CounterNotifier extends AutoDisposeNotifier<int> {
  void increment() {
    state++;
  }

  @override
  int build() {
    return 0;
  }
}
