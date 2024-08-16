/// Legacy address component object provided by google
class AddressComponent {
  /// The full text description or name of the address component
  /// as returned by the Geocoder.
  final String? longName;

  ///An abbreviated textual name for the address component, if available.
  ///For example, an address component for the state of Alaska may have
  ///a long_name of "Alaska" and a short_name of "AK" using the 2-letter postal abbreviation.
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
