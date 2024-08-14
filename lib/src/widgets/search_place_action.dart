import 'package:flutter/material.dart';

class SelectPlaceAction extends StatelessWidget {
  final String locationName;
  final String? formattedAddress;
  final String? selectActionText;
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            locationName,
            style: locationNameTextStyle ?? const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 4.0,
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
          const SizedBox(
            height: 4.0,
          ),
          if (selectActionText != null)
            ElevatedButton(
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
