// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:equatable/equatable.dart';
import 'package:konsumer/src/base/base_failure.dart';

abstract class KonsumerState extends Equatable {
  const KonsumerState({
    this.failure,
    this.loading = Loading.inline,
    this.failureDisplay = FailureDisplay.inline,
    this.loadingTitle,
    this.loadingSubtitle,
  });

  final BaseFailure? failure;
  final Loading loading;
  final FailureDisplay failureDisplay;
  final String? loadingTitle;
  final String? loadingSubtitle;

  KonsumerState setFailure(BaseFailure failure);

  KonsumerState setFailureDisplay(FailureDisplay display);

  KonsumerState setLoading({Loading loading = Loading.inline, String? title, String? subtitle, bool canDismissLoading = false});

  bool get hasFailed => failure != null;

  bool get hasLoaded => loading == Loading.none && !hasFailed;
}

/// Dictates how loading should be shown in the UI
/// LoadingDisplay.inline
/// LoadingDisplay.top
enum Loading {
  /// Show loading in the page itself
  ///
  /// For cases when a page itself is not yet ready to display content
  inline,

  /// Show loading at the end of a list
  ///
  /// For cases when pagination is required for a list
  pagination,

  /// Use this for cases when the page is ready and is visible.
  /// If the page is not yet ready or the user needs to be shown that
  /// the page is building, go with [Loading.inline]
  dialog,

  /// No loading is to be shown
  none,
}

/// Dictates how a failure is to be displayed in the UI
/// FailureDisplay.inline
/// FailureDisplay.popup
/// FailureDisplay.snackBar
enum FailureDisplay {
  /// Show failure in a popup modal (Dialog)
  dialog,

  /// Show failure in the page itself
  inline,

  /// Show failure in a snack bar
  snackBar,
}
