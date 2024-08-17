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

  const SearchInputConfig({
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.autofocus = false,
    this.showCursor,
    this.padding,
  });
}
