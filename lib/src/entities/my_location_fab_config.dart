import 'package:flutter/material.dart';

class MyLocationFABConfig {
  final Widget? child;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool mini;
  final double? elevation;
  final ShapeBorder? shape;

  /// Position in main Stack
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const MyLocationFABConfig({
    this.child,
    this.tooltip = "Locate me button",
    this.foregroundColor,
    this.backgroundColor,
    this.mini = false,
    this.elevation,
    this.shape,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}
