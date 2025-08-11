import 'package:flutter/material.dart';

class SelectedPlaceConfig {
  final Widget? actionButtonChild;

  /// Text that has to be shown on the select action button
  final String actionButtonText;
  final TextStyle? locationNameStyle;
  final TextStyle? formattedAddressStyle;
  final ButtonStyle? actionButtonStyle;
  final EdgeInsetsGeometry? contentPadding;

  const SelectedPlaceConfig({
    this.actionButtonChild,
    this.actionButtonText = 'Confirm Location',
    this.locationNameStyle,
    this.formattedAddressStyle,
    this.actionButtonStyle,
    this.contentPadding,
  });

  const SelectedPlaceConfig.init({
    this.actionButtonChild,
    this.actionButtonText = 'Confirm Location',
    this.locationNameStyle = const TextStyle(fontSize: 16),
    this.formattedAddressStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
    this.actionButtonStyle,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });
}
