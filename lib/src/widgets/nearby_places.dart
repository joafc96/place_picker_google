import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:place_picker_google/src/widgets/index.dart';
import 'package:place_picker_google/src/entities/index.dart';

class NearbyPlaces extends StatelessWidget {
  final List<NearbyPlace> nearbyPlaces;
  final Function(LatLng)? moveToLocation;

  /// Text to display nearby place
  final String? nearbyPlaceText;

  final TextStyle? nearbyPlaceItemStyle;
  final TextStyle? nearbyPlaceStyle;

  const NearbyPlaces({
    super.key,
    required this.nearbyPlaces,
    required this.nearbyPlaceText,
    this.moveToLocation,
    this.nearbyPlaceStyle,
    this.nearbyPlaceItemStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height: MediaQuery.sizeOf(context).height / 3.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Divider(),
          if (nearbyPlaceText != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: Text(
                nearbyPlaceText!,
                style: nearbyPlaceStyle ?? const TextStyle(fontSize: 16),
              ),
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: nearbyPlaces
                  .map(
                    (it) => NearbyPlaceItem(
                      nearbyPlace: it,
                      onTap: () {
                        if (it.latLng != null) {
                          moveToLocation?.call(it.latLng!);
                        }
                      },
                      nearbyPlaceStyle: nearbyPlaceItemStyle,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
