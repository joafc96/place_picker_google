class AddressComponentGG {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponentGG({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponentGG.fromJson(Map<String, dynamic> json) =>
      AddressComponentGG(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}
