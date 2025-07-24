// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:flutter_riverpod/flutter_riverpod.dart';

class KonsumerPod<KVM, S> {
  const KonsumerPod(this.vm, this.state, this.ref);

  final KVM vm;
  final S state;
  final WidgetRef ref;
}
