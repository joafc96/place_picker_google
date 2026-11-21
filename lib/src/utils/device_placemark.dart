import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

/// The one-line address of a [placemark] from the device geocoder
/// (`useFreeGeocoding`), empty when it has no address parts (open water).
///
/// The platforms fill [Placemark.street] differently: on Android it is the
/// first address line, already the whole formatted address ("100 W 1st St,
/// Los Angeles, CA 90012, USA"), so it is the address as is; on iOS it is
/// the street only ("100 W 1st St"), so the address is built from the
/// street, the locality, the administrative area with the postal code, and
/// the country ("100 W 1st St, Los Angeles, CA 90012, United States").
String placemarkAddress(Placemark placemark, {TargetPlatform? platform}) {
  final street = _nonEmpty(placemark.street);
  if ((platform ?? defaultTargetPlatform) == TargetPlatform.android &&
      street != null) {
    return street;
  }
  final region = [
    placemark.administrativeArea,
    placemark.postalCode,
  ].map(_nonEmpty).whereType<String>().join(' ');
  final parts = <String>[];
  for (final part in [street, placemark.locality, region, placemark.country]) {
    final p = _nonEmpty(part);
    if (p != null && !parts.contains(p)) parts.add(p);
  }
  return parts.join(', ');
}

/// The name of a [placemark] from the device geocoder: its own name ("Grand
/// Central Market", "100 W 1st St"), unless that is empty or only a number
/// (Android names a street address by its house number, "100"); then the
/// street line ("100 W 1st St"). Null when there is neither.
String? placemarkName(Placemark placemark, {TargetPlatform? platform}) {
  final name = _nonEmpty(placemark.name);
  if (name != null &&
      name != _nonEmpty(placemark.subThoroughfare) &&
      _letter.hasMatch(name)) {
    return name;
  }
  return _streetLine(placemark, platform ?? defaultTargetPlatform) ?? name;
}

/// The street line alone: the first part of Android's address line, the
/// street on iOS, else the street number and thoroughfare.
String? _streetLine(Placemark placemark, TargetPlatform platform) {
  final street = _nonEmpty(placemark.street);
  if (street != null) {
    return platform == TargetPlatform.android
        ? _nonEmpty(street.split(',').first)
        : street;
  }
  final line = [
    placemark.subThoroughfare,
    placemark.thoroughfare,
  ].map(_nonEmpty).whereType<String>().join(' ');
  return line.isEmpty ? null : line;
}

final RegExp _letter = RegExp(r'\p{L}', unicode: true);

String? _nonEmpty(String? s) {
  final t = s?.trim();
  return (t == null || t.isEmpty) ? null : t;
}
