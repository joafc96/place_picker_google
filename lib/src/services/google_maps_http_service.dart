import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

final kGMapsBaseUrl = Uri.parse('https://maps.googleapis.com/maps/api/');

abstract class GoogleMapsHTTPService {
  @protected
  final Client _httpClient;

  @protected
  late final Uri _url;

  @protected
  final String? _apiKey;

  @protected
  final Map<String, String>? _apiHeaders;

  Uri get url => _url;

  Client get httpClient => _httpClient;

  String? get apiKey => _apiKey;

  Map<String, String>? get apiHeaders => _apiHeaders;

  GoogleMapsHTTPService({
    required String apiPath,
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  })  : _httpClient = httpClient ?? Client(),
        _apiKey = apiKey,
        _apiHeaders = apiHeaders {
    var uri = kGMapsBaseUrl;

    if (baseUrl != null) {
      uri = Uri.parse(baseUrl);
    }

    _url = uri.replace(path: '${uri.path}$apiPath');
  }

  @protected
  String buildQuery(Map<String, dynamic> params) {
    return params.entries
        .where((entry) => entry.value != null)
        .map((entry) {
      final value = entry.value;
      if (value is Iterable) {
        return '${entry.key}=${value.map((v) => v.toString()).join("|")}';
      }
      return '${entry.key}=$value';
    })
        .join('&');
  }

  @protected
  Future<Response> doGet(String url, {Map<String, String>? headers}) async {
    return httpClient.get(Uri.parse(url), headers: headers);
  }

  @protected
  Future<Response> doPost(
      String url,
      String body, {
        Map<String, String>? headers,
      }) async {
    final postHeaders = {
      'Content-type': 'application/json',
      if (headers != null) ...headers,
    };
    return httpClient.post(Uri.parse(url), body: body, headers: postHeaders);
  }

  void dispose() => httpClient.close();
}
