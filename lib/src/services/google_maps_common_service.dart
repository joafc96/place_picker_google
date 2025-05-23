import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:place_picker_google/src/services/google_maps_http_service.dart';

class GoogleMapsCommonService extends GoogleMapsHTTPService {
  GoogleMapsCommonService({
    super.apiKey,
    super.baseUrl,
    super.httpClient,
    super.apiHeaders,
    super.apiPath = '',
  });

  Future<http.Response> geocode({
    /// Location bounds for restricting results to a radius around a location
    /// location: Location(lat: -33.867, lng: 151.195)
    LatLng? latLng,

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

    if (language != null) {
      params['language'] = language;
    }

    if (latLng != null) {
      params['latlng'] = "${latLng.latitude},${latLng.longitude}";
    }

    if (region != null) {
      params['region'] = region;
    }

    final autocompleteUrl = url
        .replace(
          path: '${url.path}geocode/json',
          queryParameters: params,
        )
        .toString();

    return await doGet(autocompleteUrl, headers: apiHeaders);
  }
}
