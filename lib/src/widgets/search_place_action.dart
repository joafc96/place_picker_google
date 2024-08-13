import 'package:flutter/material.dart';

class SelectPlaceAction extends StatelessWidget {
  final String locationName;
  final String? tapToSelectActionText;
  final VoidCallback onTap;
  final TextStyle? locationNameTextStyle;
  final TextStyle? tapToSelectActionTextStyle;

  const SelectPlaceAction({
    super.key,
    required this.locationName,
    this.tapToSelectActionText,
    required this.onTap,
    this.locationNameTextStyle,
    this.tapToSelectActionTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    locationName,
                    style:
                        locationNameTextStyle ?? const TextStyle(fontSize: 16),
                  ),
                  if (tapToSelectActionText != null)
                    Text(
                      tapToSelectActionText!,
                      style: tapToSelectActionTextStyle ??
                          const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
