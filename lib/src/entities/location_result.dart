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

  LocationResult({
    this.name,
    this.latLng,
    this.placeId,
    this.formattedAddress,
    this.postalCode,
    this.route,
    this.streetNumber,
    this.plusCode,
    this.country,
    this.locality,
    this.administrativeAreaLevel1,
    this.administrativeAreaLevel2,
    this.subLocalityLevel1,
    this.subLocalityLevel2,
  });

  /// Converts a LocationResult object to a Map (for JSON serialization).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latLng': latLng != null ? {'lat': latLng?.latitude, 'lng': latLng?.longitude} : null,
      'placeId': placeId,
      'formattedAddress': formattedAddress,
      'postalCode': postalCode?.toJson(),
      'route': route?.toJson(),
      'streetNumber': streetNumber?.toJson(),
      'plusCode': plusCode?.toJson(),
      'country': country?.toJson(),
      'locality': locality?.toJson(),
      'administrativeAreaLevel1': administrativeAreaLevel1?.toJson(),
      'administrativeAreaLevel2': administrativeAreaLevel2?.toJson(),
      'subLocalityLevel1': subLocalityLevel1?.toJson(),
      'subLocalityLevel2': subLocalityLevel2?.toJson(),
    };
  }

  /// Converts a Map (from JSON) into LocationResult object.
  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'],
      latLng: json['latLng'] != null
          ? LatLng(json['latLng']['lat'], json['latLng']['lng'])
          : null,
      placeId: json['placeId'],
      formattedAddress: json['formattedAddress'],
      postalCode: json['postalCode'] != null
          ? AddressComponent.fromJson(json['postalCode'])
          : null,
      route: json['route'] != null
          ? AddressComponent.fromJson(json['route'])
          : null,
      streetNumber: json['streetNumber'] != null
          ? AddressComponent.fromJson(json['streetNumber'])
          : null,
      plusCode: json['plusCode'] != null
          ? AddressComponent.fromJson(json['plusCode'])
          : null,
      country: json['country'] != null
          ? AddressComponent.fromJson(json['country'])
          : null,
      locality: json['locality'] != null
          ? AddressComponent.fromJson(json['locality'])
          : null,
      administrativeAreaLevel1: json['administrativeAreaLevel1'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel1'])
          : null,
      administrativeAreaLevel2: json['administrativeAreaLevel2'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel2'])
          : null,
      subLocalityLevel1: json['subLocalityLevel1'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel1'])
          : null,
      subLocalityLevel2: json['subLocalityLevel2'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel2'])
          : null,
    );
  }
}
