import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/src/entities/address_component.dart';

/// The result returned after completing location selection.
class LocationResult {
  /// The human readable name of the location. This is primarily the
  /// name of the road. But in cases where the place was selected from Nearby
  /// places list, we use the <b>name</b> provided on the list item.
  ///
  /// Contains the human-readable name for the returned result.
  /// For establishment results, this is usually the canonicalized business name.
  String? name;

  /// Latitude/Longitude of the selected location.
  LatLng? latLng;

  ///A textual identifier that uniquely identifies a place.
  ///To retrieve information about the place,
  ///pass this identifier in the place_id field of a Places API request.
  String? placeId;

  /// A string containing the human-readable address of this place.
  ///
  /// Often this address is equivalent to the postal address.
  /// Note that some countries, such as the United Kingdom, do not allow distribution
  /// of true postal addresses due to licensing restrictions.
  ///
  /// The formatted address is logically composed of one or more address components.
  /// For example, the address "111 8th Avenue, New York, NY"
  /// consists of the following components: "111" (the street number),
  /// "8th Avenue" (the route), "New York" (the city) and "NY" (the US state).
  String? formattedAddress;

  AddressComponent? postalCode;

  AddressComponent? route;

  AddressComponent? streetNumber;

  AddressComponent? plusCode;

  AddressComponent? country;

  AddressComponent? locality;

  AddressComponent? administrativeAreaLevel1;

  AddressComponent? administrativeAreaLevel2;

  AddressComponent? subLocalityLevel1;

  AddressComponent? subLocalityLevel2;
}
