import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/src/entities/auto_complete_item.dart';
import 'package:place_picker_google/src/entities/location_result.dart';

/// The result for a place picked from the autocomplete list.
///
/// Reverse geocoding the picked place's coordinates names the nearest street
/// ("300 Webster St"), not the place the user chose ("Blue Bottle Coffee").
/// This keeps the picked place's own name ([picked]'s main text) and its
/// address ([formattedAddress], from the Place Details response, else the
/// suggestion's full text), and the [geocoded] address components when
/// there are any. A pick still yields a result when reverse geocoding found
/// nothing.
LocationResult pickedPlaceResult({
  required LatLng latLng,
  required AutoCompleteItem picked,
  LocationResult? geocoded,
  String? formattedAddress,
}) {
  final result = geocoded ?? LocationResult();
  final name =
      _nonEmpty(picked.mainText) ?? result.name ?? _nonEmpty(picked.text);
  final address =
      _nonEmpty(formattedAddress) ??
      _nonEmpty(picked.text) ??
      result.formattedAddress;
  return result
    ..latLng = latLng
    ..placeId = picked.id ?? result.placeId
    ..name = name
    ..formattedAddress = address;
}

String? _nonEmpty(String? s) {
  final t = s?.trim();
  return (t == null || t.isEmpty) ? null : t;
}
