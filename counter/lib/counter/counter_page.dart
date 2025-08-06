// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:counter/counter/counter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:konsumer/konsumer.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter with KonsumerCore'),
      ),
      body: Konsumer(
        provider: counterNotifierProvider,
        onReady: (vm) => vm.init(),
        onLoadingBuilder: (_, __) {
          return const Center(
            child: Text('Yo ho custom loading'),
          );
        },
        builder: (context, pod) {
          return Scaffold(
            body: Center(
              child: Text(
                pod.state.count.toString(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                pod.vm.increment();
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
