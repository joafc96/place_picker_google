import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'google_maps_http_service.dart';

class GoogleMapsPlaces extends GoogleMapsHTTPService {
  GoogleMapsPlaces({
    super.apiKey,
    super.baseUrl,
    super.httpClient,
    super.apiHeaders,
    super.apiPath = 'place/',
  });

  Future<http.Response> autocomplete(
    /// final String input,
    String query, {
    /// Session token for Google Places API
    String? sessionToken,

    /// Offset for pagination of results
    /// offset: int,
    num? offset,

    /// Origin location for calculating distance from results
    /// origin: Location(lat: -33.852, lng: 151.211),
    LatLng? origin,

    /// Location bounds for restricting results to a radius around a location
    /// location: Location(lat: -33.867, lng: 151.195)
    LatLng? location,

    /// Radius for restricting results to a radius around a location
    /// radius: Radius in meters
    num? radius,

    /// Language code for Places API results
    /// language: 'en',
    String? language,

    /// Types for restricting results to a set of place types
    List<String> types = const [],

    /// Components set results to be restricted to a specific area
    /// components: [Component(Component.country, "us")]
    List<Component> components = const [],

    /// Bounds for restricting results to a set of bounds
    bool strictbounds = false,

    /// Region for restricting results to a set of regions
    /// region: "us"
    String? region,
  }) async {
    final params = {
      'input': query,
      if (language != null) 'language': language,
      if (origin != null) 'origin': origin.toString(),
      if (location != null) 'location': location.toString(),
      if (radius != null) 'radius': radius.toString(),
      if (types.isNotEmpty) 'types': types.join('|'),
      if (components.isNotEmpty) 'components': components.join('|'),
      if (strictbounds) 'strictbounds': strictbounds.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (region != null) 'region': region,
      if (apiKey != null) 'key': apiKey!,
      if (sessionToken != null) 'sessiontoken': sessionToken,
    };

    final autocompleteUrl = url
        .replace(
          path: '${url.path}autocomplete/json',
          queryParameters: params,
        )
        .toString();

    return await doGet(autocompleteUrl, headers: apiHeaders);
  }
}

class Component {
  static const route = 'route';
  static const locality = 'locality';
  static const administrativeArea = 'administrative_area';
  static const postalCode = 'postal_code';
  static const country = 'country';

  final String component;
  final String value;

  Component(this.component, this.value);

  @override
  String toString() => '$component:$value';
}
