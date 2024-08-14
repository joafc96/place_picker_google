import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectPlaceAction extends StatelessWidget {
  /// Name of the selected place
  final String locationName;

  /// Formatted address of the selected place
  final String? formattedAddress;

  /// Text that has to be shown on the select action button
  final String? selectActionText;

  /// Optional void call back of the button
  final VoidCallback? onTap;

  final TextStyle? locationNameTextStyle;
  final TextStyle? tapToSelectActionTextStyle;
  final TextStyle? formattedAddressTextStyle;

  const SelectPlaceAction({
    super.key,
    required this.locationName,
    required this.onTap,
    this.formattedAddress,
    this.selectActionText,
    this.locationNameTextStyle,
    this.tapToSelectActionTextStyle,
    this.formattedAddressTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            locationName,
            style: locationNameTextStyle ?? const TextStyle(fontSize: 16),
          ),
          if (formattedAddress != null)
            Text(
              formattedAddress!,
              style: formattedAddressTextStyle ??
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
            ),
          if (selectActionText != null)
            const SizedBox(
              height: 12.0,
            ),
          if (selectActionText != null)
            CupertinoButton(
              color: Theme.of(context).primaryColor,
              onPressed: onTap,
              child: Text(
                selectActionText!,
                style: tapToSelectActionTextStyle,
              ),
            ),
        ],
      ),
    );
  }
}
