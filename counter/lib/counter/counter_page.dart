// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:counter/counter/counter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:konsumer_core/konsumer_core.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KonsumerCore(
      provider: counterNotifierProvider,
      builder: (context, notifier, state, ref) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Counter with KonsumerCore'),
          ),
          body: Center(
            child: Text(
              state.toString(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: notifier.increment,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
