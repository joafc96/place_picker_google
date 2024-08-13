import 'package:flutter/material.dart';
import 'package:google_place_picker/src/entities/index.dart';

class NearbyPlaceItem extends StatelessWidget {
  final NearbyPlace nearbyPlace;
  final VoidCallback onTap;

  const NearbyPlaceItem(this.nearbyPlace, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: <Widget>[
              Image.network(nearbyPlace.icon!, width: 16),
              SizedBox(width: 24),
              Expanded(child: Text("${nearbyPlace.name}", style: TextStyle(fontSize: 16)))
            ],
          ),
        ),
      ),
    );
  }
}
