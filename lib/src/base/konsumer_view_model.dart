// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konsumer/src/base/konsumer_state.dart';

abstract class KonsumerViewModel<S extends KonsumerState> extends AutoDisposeNotifier<S> {
  S emit(S state);
}

abstract class StickyKonsumerViewModel<S extends KonsumerState> extends Notifier<S> {}
