import 'package:flutter/material.dart';

import '../../place_picker_google.dart';

class SelectedPlace extends StatelessWidget {
  /// Name of the selected place
  final String? locationName;

  /// Formatted address of the selected place
  final String? formattedAddress;

  /// Optional void call back of the button
  final VoidCallback? onTap;

  final SelectedPlaceConfig selectedPlaceConfig;

  const SelectedPlace({
    super.key,
    required this.onTap,
    required this.selectedPlaceConfig,
    this.locationName,
    this.formattedAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: selectedPlaceConfig.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (locationName != null)
            Text(locationName!, style: selectedPlaceConfig.locationNameStyle),
          if (formattedAddress != null)
            Text(
              formattedAddress!,
              style: selectedPlaceConfig.formattedAddressStyle,
            ),
          const SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
            onPressed: onTap,
            style: selectedPlaceConfig.actionButtonStyle,
            child: selectedPlaceConfig.actionButtonChild ??
                Text(selectedPlaceConfig.actionButtonText),
          ),
        ],
      ),
    );
  }
}
