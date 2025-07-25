// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konsumer/src/base/konsumer_state.dart';
import 'package:konsumer/src/base/konsumer_view_model.dart';
import 'package:konsumer/src/konsumer_pod.dart';
import 'package:konsumer_core/konsumer_core.dart';
import 'package:statetris/statetris.dart';

typedef KBuilder<VM, S> = Widget Function(BuildContext, KonsumerPod<VM, S>);
typedef KListen<VM, S> = void Function(BuildContext, KonsumerPod<VM, S>);
typedef KOnReady<VM> = void Function(VM);

class Konsumer<VM extends KonsumerViewModel<S>, S extends KonsumerState> extends StatelessWidget {
  const Konsumer({
    super.key,
    required this.provider,
    required this.builder,
    this.onReady,
    this.listen,
    this.onActionBuilder,
    this.onLoadingBuilder,
    this.onErrorBuilder,
    this.loadingAssetBuilder,
    this.errorAssetBuilder,
  });

  final AutoDisposeNotifierProvider<VM, S> provider;

  final KBuilder<VM, S> builder;
  final KBuilder<VM, S>? onActionBuilder;
  final KBuilder<VM, S>? onLoadingBuilder;
  final KBuilder<VM, S>? onErrorBuilder;
  final KBuilder<VM, S>? loadingAssetBuilder;
  final KBuilder<VM, S>? errorAssetBuilder;

  final KListen<VM, S>? listen;
  final KOnReady<VM>? onReady;

  @override
  Widget build(BuildContext context) {
    return KonsumerCore(
      provider: provider,
      builder: (context, vm, state, ref) {
        final pod = KonsumerPod(vm, state, ref);
        return _Konsumer(
          state: state,
          builder: (context) => builder(context, pod),
          onActionBuilder: onActionBuilder == null ? null : (context) => onActionBuilder!(context, pod),
          onLoadingBuilder: onLoadingBuilder == null ? null : (context) => onLoadingBuilder!(context, pod),
          onErrorBuilder: onErrorBuilder == null ? null : (context) => onErrorBuilder!(context, pod),
          loadingAssetBuilder: loadingAssetBuilder == null ? null : (context) => loadingAssetBuilder!(context, pod),
          errorAssetBuilder: errorAssetBuilder == null ? null : (context) => errorAssetBuilder!(context, pod),
        );
      },
      onReady: onReady,
      listen: (context, notifier, state, ref) => listen?.call(
        context,
        KonsumerPod(notifier, state, ref),
      ),
    );
  }
}

class StickyKonsumer<VM extends StickyKonsumerViewModel<S>, S extends KonsumerState> extends StatelessWidget {
  const StickyKonsumer({
    super.key,
    required this.provider,
    required this.builder,
    this.onReady,
    this.listen,
    this.onActionBuilder,
    this.onLoadingBuilder,
    this.onErrorBuilder,
    this.loadingAssetBuilder,
    this.errorAssetBuilder,
  });

  final NotifierProvider<VM, S> provider;

  final KBuilder<VM, S> builder;
  final KBuilder<VM, S>? onActionBuilder;
  final KBuilder<VM, S>? onLoadingBuilder;
  final KBuilder<VM, S>? onErrorBuilder;
  final KBuilder<VM, S>? loadingAssetBuilder;
  final KBuilder<VM, S>? errorAssetBuilder;

  final KListen<VM, S>? listen;
  final KOnReady<VM>? onReady;

  @override
  Widget build(BuildContext context) {
    return StickyKonsumerCore(
      provider: provider,
      builder: (context, vm, state, ref) {
        final pod = KonsumerPod(vm, state, ref);
        return _Konsumer(
          state: state,
          builder: (context) => builder(context, pod),
          onActionBuilder: onActionBuilder == null ? null : (context) => onActionBuilder!(context, pod),
          onLoadingBuilder: onLoadingBuilder == null ? null : (context) => onLoadingBuilder!(context, pod),
          onErrorBuilder: onErrorBuilder == null ? null : (context) => onErrorBuilder!(context, pod),
          loadingAssetBuilder: loadingAssetBuilder == null ? null : (context) => loadingAssetBuilder!(context, pod),
          errorAssetBuilder: errorAssetBuilder == null ? null : (context) => errorAssetBuilder!(context, pod),
        );
      },
      onReady: onReady,
      listen: (context, notifier, state, ref) => listen?.call(
        context,
        KonsumerPod(notifier, state, ref),
      ),
    );
  }
}

class _Konsumer<S extends KonsumerState> extends StatelessWidget {
  const _Konsumer({
    required this.state,
    required this.builder,
    required this.onActionBuilder,
    required this.onLoadingBuilder,
    required this.onErrorBuilder,
    required this.loadingAssetBuilder,
    required this.errorAssetBuilder,
  });

  final S state;
  final WidgetBuilder builder;

  final WidgetBuilder? onActionBuilder;
  final WidgetBuilder? onLoadingBuilder;
  final WidgetBuilder? onErrorBuilder;
  final WidgetBuilder? loadingAssetBuilder;
  final WidgetBuilder? errorAssetBuilder;

  @override
  Widget build(BuildContext context) {
    return Statetris(
      mode: _computeMode(state),
      builder: (context) => builder(context),
      onLoadingBuilder: onLoadingBuilder,
      onLoadingStateBuilder: onLoadingBuilder == null
          ? (_) => StatePod.loading(
              title: state.loadingTitle == null ? null : Text(state.loadingTitle!),
              subtitle: state.loadingSubtitle == null ? null : Text(state.loadingSubtitle!),
              asset: loadingAssetBuilder?.call(context),
            )
          : null,
      onErrorBuilder: onErrorBuilder,
      onErrorStateBuilder: onErrorBuilder == null
          ? (_) => StatePod.error(
              asset: errorAssetBuilder?.call(context),
              title: (state.failure?.message == null) ? null : Text(state.failure?.message ?? ''),
              subtitle: (state.failure?.detail == null) ? null : Text(state.failure?.detail ?? ''),
              action: onActionBuilder?.call(context),
            )
          : null,
    );
  }

  StatetrisMode _computeMode(S state) {
    if (state.loading == Loading.inline) return StatetrisMode.loading;

    if (state.hasFailed) return StatetrisMode.error;

    return StatetrisMode.loaded;
  }
}
