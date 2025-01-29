import 'package:flutter/material.dart';

class SearchInputConfig {
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool? showCursor;
  final EdgeInsetsGeometry? padding;
  final TextAlignVertical? textAlignVertical;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const SearchInputConfig({
    this.style,
    this.textDirection,
    this.showCursor,
    this.padding,
    this.focusNode,
    this.keyboardType,
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
  });
}
