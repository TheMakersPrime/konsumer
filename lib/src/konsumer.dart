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
typedef OnHandleState<S> = KonsumerUiState Function(S);

class Konsumer<VM extends KonsumerViewModel<S>, S extends KonsumerState> extends StatelessWidget {
  const Konsumer({
    super.key,
    required this.provider,
    required this.builder,
    this.onReady,
    this.listen,
    this.actionBuilder,
    this.errorBuilder,
    this.loadingAssetBuilder,
    this.errorAssetBuilder,
    this.onHandleState,
  });

  final AutoDisposeNotifierProvider<VM, S> provider;

  final KBuilder<VM, S> builder;
  final KBuilder<VM, S>? actionBuilder;
  final KBuilder<VM, S>? errorBuilder;
  final KBuilder<VM, S>? loadingAssetBuilder;
  final KBuilder<VM, S>? errorAssetBuilder;

  final KListen<VM, S>? listen;
  final KOnReady<VM>? onReady;
  final OnHandleState<S>? onHandleState;

  @override
  Widget build(BuildContext context) {
    return KonsumerCore(
      provider: provider,
      builder: (context, vm, state, ref) {
        final pod = KonsumerPod(vm, state, ref);

        return _Konsumer(
          state: state,
          onHandleState: onHandleState,
          builder: (context) => builder(context, pod),
          actionBuilder: actionBuilder == null ? null : (context) => actionBuilder!(context, pod),
          errorBuilder: errorBuilder == null ? null : (context) => errorBuilder!(context, pod),
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
    this.actionBuilder,
    this.errorBuilder,
    this.loadingAssetBuilder,
    this.errorAssetBuilder,
    this.onHandleState,
  });

  final NotifierProvider<VM, S> provider;

  final KBuilder<VM, S> builder;
  final KBuilder<VM, S>? actionBuilder;
  final KBuilder<VM, S>? errorBuilder;
  final KBuilder<VM, S>? loadingAssetBuilder;
  final KBuilder<VM, S>? errorAssetBuilder;

  final KListen<VM, S>? listen;
  final KOnReady<VM>? onReady;
  final OnHandleState<S>? onHandleState;

  @override
  Widget build(BuildContext context) {
    return StickyKonsumerCore(
      provider: provider,
      builder: (context, vm, state, ref) {
        final pod = KonsumerPod(vm, state, ref);

        return _Konsumer(
          state: state,
          onHandleState: onHandleState,
          builder: (context) => builder(context, pod),
          actionBuilder: actionBuilder == null ? null : (context) => actionBuilder!(context, pod),
          errorBuilder: errorBuilder == null ? null : (context) => errorBuilder!(context, pod),
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
    required this.onHandleState,
    required this.builder,
    required this.actionBuilder,
    required this.errorBuilder,
    required this.loadingAssetBuilder,
    required this.errorAssetBuilder,
  });

  final S state;
  final OnHandleState<S>? onHandleState;
  final WidgetBuilder builder;

  final WidgetBuilder? actionBuilder;
  final WidgetBuilder? errorBuilder;
  final WidgetBuilder? loadingAssetBuilder;
  final WidgetBuilder? errorAssetBuilder;

  @override
  Widget build(BuildContext context) {
    final stateHandler = onHandleState?.call(state) ?? KonsumerUiState.all;

    if (stateHandler == KonsumerUiState.none) return builder(context);

    final _allowLoading = stateHandler == KonsumerUiState.all || stateHandler == KonsumerUiState.loading;
    final _allowError = stateHandler == KonsumerUiState.all || stateHandler == KonsumerUiState.failure;

    final handleLoading = _allowLoading && state.loading == Loading.inline;
    final handleError = _allowError && state.hasFailed && state.failureDisplay == FailureDisplay.inline;

    return Statetris(
      mode: _computeMode(state),
      builder: (context) => builder(context),
      onLoadingStateBuilder: handleLoading
          ? (_) => StatePod.loading(
              title: state.loadingTitle == null ? null : Text(state.loadingTitle!),
              subtitle: state.loadingSubtitle == null ? null : Text(state.loadingSubtitle!),
              asset: loadingAssetBuilder?.call(context),
            )
          : null,
      onErrorBuilder: handleError ? errorBuilder : null,
      onErrorStateBuilder: handleError && errorBuilder == null
          ? (_) => StatePod.error(
              asset: errorAssetBuilder?.call(context),
              title: (state.failure?.message == null) ? null : Text(state.failure?.message ?? ''),
              subtitle: (state.failure?.detail == null) ? null : Text(state.failure?.detail ?? ''),
              action: actionBuilder?.call(context),
            )
          : null,
    );
  }
}

enum KonsumerUiState {
  all,
  none,
  loading,
  failure,
}

StatetrisMode _computeMode<S extends KonsumerState>(S state) {
  if (state.loading == Loading.inline) return StatetrisMode.loading;

  if (state.hasFailed) return StatetrisMode.error;

  return StatetrisMode.loaded;
}
