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

    /// Bounds for restricting results to a set of bounds
    bool strictBounds = false,

    /// Region for restricting results to a set of regions
    /// region: "us"
    String? region,
  }) async {
    final params = {
      'input': query,
      if (apiKey != null) 'key': apiKey,
      if (location != null)
        'location': "${location.latitude}, ${location.longitude}",
      if (language != null) 'language': language,
      if (origin != null) 'origin': origin.toString(),
      if (radius != null) 'radius': radius.toString(),
      if (types.isNotEmpty) 'types': types.join('|'),
      if (strictBounds) 'strictbounds': strictBounds.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (region != null) 'region': region,
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
    final params = {
      if (apiKey != null) 'key': apiKey,
      'location': "${location.latitude}, ${location.longitude}",
      'radius': radius.toString(),
      if (language != null) 'language': language,
      if (type != null) 'type': type,
      if (keyword != null) 'keyword': keyword,
    };

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
    final params = {
      'placeid': placeId,
      if (apiKey != null) 'key': apiKey!,
      if (sessionToken != null) 'sessiontoken': sessionToken,
      if (language != null) 'language': language,
      if (region != null) 'region': region,
      if (fields.isNotEmpty) 'fields': fields.join(','),
    };

    final detailsUrl = url
        .replace(
          path: '${url.path}details/json',
          queryParameters: params,
        )
        .toString();

    return await doGet(detailsUrl, headers: apiHeaders);
  }
}
