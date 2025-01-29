import 'dart:convert';
import 'index.dart';

GeocodingResponse geocodingResponseFromJson(String str) =>
    GeocodingResponse.fromJson(json.decode(str));

class GeocodingResponse {
  final List<GeocodingResultGG>? results;
  final String? status;

  GeocodingResponse({
    this.results,
    this.status,
  });

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      GeocodingResponse(
        results: json["results"] == null
            ? []
            : List<GeocodingResultGG>.from(
                json["results"]!.map((x) => GeocodingResultGG.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
      };
}
