import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_place_picker/src/widgets/index.dart';
import 'package:google_place_picker/src/entities/index.dart';

class NearbyPlaces extends StatelessWidget {
  final List<NearbyPlace> nearbyPlaces;
  final Function(LatLng)? moveToLocation;
  final String? nearbyText;
  final TextStyle? nearbyPlaceItemStyle;

  const NearbyPlaces({
    super.key,
    required this.nearbyPlaces,
    required this.nearbyText,
    this.moveToLocation,
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
          if (nearbyText != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: Text(
                nearbyText!,
                style: TextStyle(fontSize: 16),
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
