import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:place_picker_google/place_picker_google.dart';

class GoogleAPIParameters {
  /// Session token for Google Places API
  final String? sessionToken;

  /// Offset for pagination of results
  /// offset: int,
  final num? offset;

  /// Origin location for calculating distance from results
  /// origin: Location(lat: -33.852, lng: 151.211),
  final LatLng? origin;

  /// Radius for restricting results to a radius around a location
  /// radius: Radius in meters
  final num? radius;

  /// Language code for Places API results
  /// language: 'en',
  final String language;

  /// Bounds for restricting results to a set of bounds
  final bool strictbounds;

  /// Region for restricting results to a set of regions
  /// region: "us"
  final String region;

  /// Types for restricting results to a set of place types
  final List<String> types;

  /// Components set results to be restricted to a specific area
  /// components: [Component(Component.country, "us")]
  final List<Component> components;

  /// List of fields to be returned by the Google Maps Places API.
  /// Refer to the Google Documentation here for a list of valid values: https://developers.google.com/maps/documentation/places/web-service/details
  final List<String> fields;

  const GoogleAPIParameters({
    this.sessionToken,
    this.offset,
    this.origin,
    this.radius,
    this.language = "en",
    this.region = "us",
    this.strictbounds = false,
    this.types = const [],
    this.components = const [],
    this.fields = const [],
  });
}
