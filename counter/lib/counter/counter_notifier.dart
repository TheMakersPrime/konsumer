// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foundation/foundation.dart';

final counterNotifierProvider = AutoDisposeNotifierProvider(CounterViewModel.new);

class CounterState extends StateFoundation {
  const CounterState({required this.count, super.loading, super.failure});

  final int count;

  @override
  List<Object?> get props => [count];

  @override
  CounterState setFailure(FailureFoundation failure) {
    return CounterState(
      count: count,
      failure: failure,
    );
  }

  @override
  CounterState setFailureDisplay(FailureDisplay display) {
    throw UnimplementedError();
  }

  @override
  CounterState setLoading({
    Loading loading = Loading.inline,
    String? title,
    String? subtitle,
    bool canDismissLoading = false,
  }) {
    return CounterState(count: count, loading: Loading.none);
  }

  @override
  String toString() {
    return '$count | $failure | $loading';
  }
}

class CounterViewModel extends ViewModelFoundation<CounterState> {
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 4));
    state = const CounterState(
      count: 0,
      failure: FailureFoundation('La mya fail bhayo'),
      loading: Loading.none,
    );
    await Future.delayed(const Duration(seconds: 4));
    state = const CounterState(count: 0, loading: Loading.none);
  }

  void increment() {
    state = CounterState(count: state.count + 1, loading: Loading.none);
  }

  @override
  CounterState build() {
    return const CounterState(count: 0);
  }
}
