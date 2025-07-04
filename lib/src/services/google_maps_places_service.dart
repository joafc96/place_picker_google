import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:place_picker_google/src/entities/component.dart';
import 'package:place_picker_google/src/services/google_maps_http_service.dart';

class GoogleMapsPlacesService extends GoogleMapsHTTPService {
  GoogleMapsPlacesService({
    super.apiKey,
    super.baseUrl,
    super.httpClient,
    super.apiHeaders,
    super.apiPath = 'place/',
  });

  Future<http.Response> autocomplete(
    /// final String input,
    String input, {
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
    List<Component> components = const [],

    /// Bounds for restricting results to a set of bounds
    bool strictBounds = false,

    /// Region for restricting results to a set of regions
    /// region: "us"
    String? region,
  }) async {
    final params = <String, String>{
      'input': input,
    };

    if (language != null) {
      params['language'] = language;
    }

    if (origin != null) {
      params['origin'] = origin.toString();
    }

    if (location != null) {
      params['location'] = '${location.latitude},${location.longitude}';
    }

    if (radius != null) {
      params['radius'] = radius.toString();
    }

    if (types.isNotEmpty) {
      params['types'] = types.join('|');
    }

    if (components.isNotEmpty) {
      params['components'] = components.join('|');
    }

    if (strictBounds) {
      params['strictbounds'] = strictBounds.toString();
    }

    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (region != null) {
      params['region'] = region;
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    final autocompleteUrl = url
        .replace(
          path: '${url.path}autocomplete/json',
          queryParameters: params,
        )
        .toString();

    return await doGet(autocompleteUrl, headers: apiHeaders);
  }

  Future<http.Response> nearbySearch(
    /// Location bounds for restricting results to a radius around a location
    /// location: Location(lat: -33.867, lng: 151.195)
    LatLng location, {
    /// Radius for restricting results to a radius around a location
    /// radius: Radius in meters
    num radius = 150,

    /// Type for restricting results to a set of place types
    String? type,
    String? keyword,

    /// Language code for Places API results
    /// language: 'en',
    String? language,
  }) async {
    final params = <String, String>{};

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    params['location'] = '${location.latitude},${location.longitude}';
    params['radius'] = radius.toString();

    if (keyword != null) {
      params['keyword'] = keyword;
    }

    if (type != null) {
      params['type'] = type;
    }

    if (language != null) {
      params['language'] = language;
    }

    final nearbySearchUrl = url
        .replace(
          path: '${url.path}nearbysearch/json',
          queryParameters: params,
        )
        .toString();

    return await doGet(nearbySearchUrl, headers: apiHeaders);
  }

  Future<http.Response> details(
    /// Place ID provided google to decode and get the details.
    /// A textual identifier that uniquely identifies a place, returned from a Place Search.
    String placeId, {
    /// Session token for Google Places API
    String? sessionToken,
    List<String> fields = const [],

    /// Language code for Places API results
    /// language: 'en',
    String? language,

    /// Region for restricting results to a set of regions
    /// region: "us"
    String? region,
  }) async {
    final params = <String, String>{};

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    params['placeid'] = placeId;

    if (language != null) {
      params['language'] = language;
    }

    if (region != null) {
      params['region'] = region;
    }

    if (fields.isNotEmpty) {
      params['fields'] = fields.join(',');
    }

    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    final detailsUrl = url
        .replace(
          path: '${url.path}details/json',
          queryParameters: params,
        )
        .toString();

    return await doGet(detailsUrl, headers: apiHeaders);
  }
}
