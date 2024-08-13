class AddressComponent {
  final String? longName;
  final String? shortName;

  const AddressComponent({
    this.longName,
    this.shortName,
  });

  static AddressComponent fromJson(dynamic json) {
    return AddressComponent(
      longName: json['long_name'],
      shortName: json['short_name'],
    );
  }
}
