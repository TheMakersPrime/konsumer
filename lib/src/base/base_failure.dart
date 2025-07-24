// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:equatable/equatable.dart';

abstract class BaseFailure extends Equatable implements Exception {
  const BaseFailure(
    this.message, {
    this.detail,
    this.stackTrace,
  });

  final String message;
  final String? detail;
  final StackTrace? stackTrace;
}
