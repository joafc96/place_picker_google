import 'package:flutter/material.dart';

class SelectPlaceWidget extends StatelessWidget {
  /// Name of the selected place
  final String locationName;

  /// Formatted address of the selected place
  final String? formattedAddress;

  /// Text that has to be shown on the select action button
  final String? actionText;

  /// Optional void call back of the button
  final VoidCallback? onTap;

  final TextStyle? locationNameStyle;
  final TextStyle? formattedAddressStyle;
  final Widget? actionChild;

  const SelectPlaceWidget({
    super.key,
    required this.locationName,
    required this.onTap,
    this.formattedAddress,
    this.actionText,
    this.locationNameStyle,
    this.formattedAddressStyle,
    this.actionChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            locationName,
            style: locationNameStyle ?? const TextStyle(fontSize: 16),
          ),
          if (formattedAddress != null)
            Text(
              formattedAddress!,
              style: formattedAddressStyle ??
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
            ),
          if (actionText != null)
            const SizedBox(
              height: 12.0,
            ),
          if (actionText != null)
            ElevatedButton(
              onPressed: onTap,
              child: actionChild ?? Text(actionText!),
            ),
        ],
      ),
    );
  }
}
