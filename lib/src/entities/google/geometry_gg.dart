import 'index.dart';

class GeometryGG {
  final LocationGG? location;
  final String? locationType;
  final ViewportGG? viewport;

  GeometryGG({
    this.location,
    this.locationType,
    this.viewport,
  });

  factory GeometryGG.fromJson(Map<String, dynamic> json) => GeometryGG(
        location: json["location"] == null
            ? null
            : LocationGG.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: json["viewport"] == null
            ? null
            : ViewportGG.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationType,
        "viewport": viewport?.toJson(),
      };
}
