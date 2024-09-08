import 'index.dart';

class ViewportGG {
  final LocationGG? northeast;
  final LocationGG? southwest;

  ViewportGG({
    this.northeast,
    this.southwest,
  });

  factory ViewportGG.fromJson(Map<String, dynamic> json) => ViewportGG(
        northeast: json["northeast"] == null
            ? null
            : LocationGG.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : LocationGG.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}
