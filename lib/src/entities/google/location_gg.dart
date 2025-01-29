class LocationGG {
  final double? lat;
  final double? lng;

  LocationGG({
    this.lat,
    this.lng,
  });

  factory LocationGG.fromJson(Map<String, dynamic> json) => LocationGG(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
