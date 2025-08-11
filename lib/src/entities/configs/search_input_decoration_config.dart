import 'package:flutter/material.dart';

class SearchInputDecorationConfig {
  final Widget? label;
  final String? labelText;
  final TextStyle? labelStyle;

  final String? helperText;
  final TextStyle? helperStyle;
  final int? helperMaxLines;

  final String? hintText;
  final TextStyle? hintStyle;
  final TextDirection? hintTextDirection;
  final int? hintMaxLines;
  final Duration? hintFadeDuration;

  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Color? prefixIconColor;
  final String? prefixText;
  final TextStyle? prefixStyle;

  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final Color? suffixIconColor;
  final String? suffixText;
  final TextStyle? suffixStyle;

  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? border;

  final bool? isDense;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final BoxConstraints? constraints;

  const SearchInputDecorationConfig({
    this.label,
    this.labelText,
    this.labelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintText,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.hintFadeDuration,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefixText,
    this.prefixStyle,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    this.isDense,
    this.filled = true,
    this.fillColor,
    this.contentPadding,
    this.enabled = true,
    this.constraints,
  });
}
