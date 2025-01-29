import 'index.dart';

class GeocodingResultGG {
  final List<AddressComponentGG>? addressComponents;
  final String? formattedAddress;
  final GeometryGG? geometry;
  final String? placeId;
  final PlusCodeGG? plusCode;
  final List<String>? types;

  GeocodingResultGG({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.plusCode,
    this.types,
  });

  factory GeocodingResultGG.fromJson(Map<String, dynamic> json) =>
      GeocodingResultGG(
        addressComponents: json["address_components"] == null
            ? []
            : List<AddressComponentGG>.from(json["address_components"]!
                .map((x) => AddressComponentGG.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : GeometryGG.fromJson(json["geometry"]),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCodeGG.fromJson(json["plus_code"]),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null
            ? []
            : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}
