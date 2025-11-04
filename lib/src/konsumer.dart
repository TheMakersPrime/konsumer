// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foundation/foundation.dart';
import 'package:konsumer_core/konsumer_core.dart';
import 'package:statetris/statetris.dart';

class Konsumer<VM extends AutoDisposeNotifier<S>, S extends StateFoundation> extends StatelessWidget {
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
    this.onIsLoading,
    this.onHasFailed,
  });

  final AutoDisposeNotifierProvider<VM, S> provider;

  final KonsumerBuilder<VM, S> builder;
  final KonsumerBuilder<VM, S>? onActionBuilder;
  final KonsumerBuilder<VM, S>? onLoadingBuilder;
  final KonsumerBuilder<VM, S>? onErrorBuilder;
  final KonsumerBuilder<VM, S>? loadingAssetBuilder;
  final KonsumerBuilder<VM, S>? errorAssetBuilder;

  final KonsumerListen<VM, S>? listen;
  final KonsumerOnReady<VM>? onReady;

  final bool Function(S)? onIsLoading;
  final bool Function(S)? onHasFailed;

  @override
  Widget build(BuildContext context) {
    return KonsumerCore(
      provider: provider,
      builder: (context, pod) {
        return _Konsumer(
          state: pod.state,
          builder: (context) => builder(context, pod),
          onActionBuilder: onActionBuilder == null ? null : (context) => onActionBuilder!(context, pod),
          onLoadingBuilder: onLoadingBuilder == null ? null : (context) => onLoadingBuilder!(context, pod),
          onErrorBuilder: onErrorBuilder == null ? null : (context) => onErrorBuilder!(context, pod),
          loadingAssetBuilder: loadingAssetBuilder == null ? null : (context) => loadingAssetBuilder!(context, pod),
          errorAssetBuilder: errorAssetBuilder == null ? null : (context) => errorAssetBuilder!(context, pod),
          onIsLoading: onIsLoading,
          onHasFailed: onHasFailed,
        );
      },
      onReady: onReady,
      listen: listen,
    );
  }
}

class StickyKonsumer<VM extends Notifier<S>, S extends StateFoundation> extends StatelessWidget {
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
    this.onIsLoading,
    this.onHasFailed,
  });

  final NotifierProvider<VM, S> provider;

  final KonsumerBuilder<VM, S> builder;
  final KonsumerBuilder<VM, S>? onActionBuilder;
  final KonsumerBuilder<VM, S>? onLoadingBuilder;
  final KonsumerBuilder<VM, S>? onErrorBuilder;
  final KonsumerBuilder<VM, S>? loadingAssetBuilder;
  final KonsumerBuilder<VM, S>? errorAssetBuilder;

  final KonsumerListen<VM, S>? listen;
  final KonsumerOnReady<VM>? onReady;

  final bool Function(S)? onIsLoading;
  final bool Function(S)? onHasFailed;

  @override
  Widget build(BuildContext context) {
    return StickyKonsumerCore(
      provider: provider,
      builder: (context, pod) {
        return _Konsumer(
          state: pod.state,
          builder: (context) => builder(context, pod),
          onActionBuilder: onActionBuilder == null ? null : (context) => onActionBuilder!(context, pod),
          onLoadingBuilder: onLoadingBuilder == null ? null : (context) => onLoadingBuilder!(context, pod),
          onErrorBuilder: onErrorBuilder == null ? null : (context) => onErrorBuilder!(context, pod),
          loadingAssetBuilder: loadingAssetBuilder == null ? null : (context) => loadingAssetBuilder!(context, pod),
          errorAssetBuilder: errorAssetBuilder == null ? null : (context) => errorAssetBuilder!(context, pod),
          onIsLoading: onIsLoading,
          onHasFailed: onHasFailed,
        );
      },
      onReady: onReady,
      listen: listen,
    );
  }
}

class _Konsumer<S extends StateFoundation> extends StatelessWidget {
  const _Konsumer({
    required this.state,
    required this.builder,
    required this.onActionBuilder,
    required this.onLoadingBuilder,
    required this.onErrorBuilder,
    required this.loadingAssetBuilder,
    required this.errorAssetBuilder,
    required this.onIsLoading,
    required this.onHasFailed,
  });

  final S state;
  final WidgetBuilder builder;

  final WidgetBuilder? onActionBuilder;
  final WidgetBuilder? onLoadingBuilder;
  final WidgetBuilder? onErrorBuilder;
  final WidgetBuilder? loadingAssetBuilder;
  final WidgetBuilder? errorAssetBuilder;
  final bool Function(S)? onIsLoading;
  final bool Function(S)? onHasFailed;

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
              title: (state.failureMessage == null) ? null : Text(state.failureMessage ?? ''),
              subtitle: (state.failureDetail == null) ? null : Text(state.failureDetail ?? ''),
              action: onActionBuilder?.call(context),
            )
          : null,
    );
  }

  StatetrisMode _computeMode(S state) {
    if (onIsLoading?.call(state) ?? state.isLoading) return StatetrisMode.loading;

    if (onHasFailed?.call(state) ?? state.hasFailed) return StatetrisMode.error;

    return StatetrisMode.loaded;
  }
}
