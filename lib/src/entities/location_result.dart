import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

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

  NearbyPlace? nearbyPlace;

  AddressComponent? postalCode;

  AddressComponent? route;

  AddressComponent? streetNumber;

  AddressComponent? plusCode;

  AddressComponent? country;

  AddressComponent? locality;

  AddressComponent? administrativeAreaLevel1;

  AddressComponent? administrativeAreaLevel2;

  AddressComponent? administrativeAreaLevel3;

  AddressComponent? administrativeAreaLevel4;

  AddressComponent? administrativeAreaLevel5;

  AddressComponent? administrativeAreaLevel6;

  AddressComponent? administrativeAreaLevel7;

  AddressComponent? subLocalityLevel1;

  AddressComponent? subLocalityLevel2;

  AddressComponent? subLocalityLevel3;

  AddressComponent? subLocalityLevel4;

  AddressComponent? subLocalityLevel5;

  LocationResult({
    this.name,
    this.latLng,
    this.placeId,
    this.formattedAddress,
    this.nearbyPlace,
    this.postalCode,
    this.route,
    this.streetNumber,
    this.plusCode,
    this.country,
    this.locality,
    this.administrativeAreaLevel1,
    this.administrativeAreaLevel2,
    this.administrativeAreaLevel3,
    this.administrativeAreaLevel4,
    this.administrativeAreaLevel5,
    this.administrativeAreaLevel6,
    this.administrativeAreaLevel7,
    this.subLocalityLevel1,
    this.subLocalityLevel2,
    this.subLocalityLevel3,
    this.subLocalityLevel4,
    this.subLocalityLevel5,
  });

  /// Converts a LocationResult object to a Map (for JSON serialization).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latLng': latLng != null
          ? {'lat': latLng?.latitude, 'lng': latLng?.longitude}
          : null,
      'placeId': placeId,
      'formattedAddress': formattedAddress,
      'nearbyPlace': nearbyPlace?.toJson(),
      'postalCode': postalCode?.toJson(),
      'route': route?.toJson(),
      'streetNumber': streetNumber?.toJson(),
      'plusCode': plusCode?.toJson(),
      'country': country?.toJson(),
      'locality': locality?.toJson(),
      'administrativeAreaLevel1': administrativeAreaLevel1?.toJson(),
      'administrativeAreaLevel2': administrativeAreaLevel2?.toJson(),
      'administrativeAreaLevel3': administrativeAreaLevel3?.toJson(),
      'administrativeAreaLevel4': administrativeAreaLevel4?.toJson(),
      'administrativeAreaLevel5': administrativeAreaLevel5?.toJson(),
      'administrativeAreaLevel6': administrativeAreaLevel6?.toJson(),
      'administrativeAreaLevel7': administrativeAreaLevel7?.toJson(),
      'subLocalityLevel1': subLocalityLevel1?.toJson(),
      'subLocalityLevel2': subLocalityLevel2?.toJson(),
      'subLocalityLevel3': subLocalityLevel3?.toJson(),
      'subLocalityLevel4': subLocalityLevel4?.toJson(),
      'subLocalityLevel5': subLocalityLevel5?.toJson(),
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
      nearbyPlace: json['nearbyPlace'] != null
          ? NearbyPlace.fromJson(json['nearbyPlace'])
          : null,
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
      administrativeAreaLevel3: json['administrativeAreaLevel3'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel3'])
          : null,
      administrativeAreaLevel4: json['administrativeAreaLevel4'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel4'])
          : null,
      administrativeAreaLevel5: json['administrativeAreaLevel5'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel5'])
          : null,
      administrativeAreaLevel6: json['administrativeAreaLevel6'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel6'])
          : null,
      administrativeAreaLevel7: json['administrativeAreaLevel7'] != null
          ? AddressComponent.fromJson(json['administrativeAreaLevel7'])
          : null,
      subLocalityLevel1: json['subLocalityLevel1'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel1'])
          : null,
      subLocalityLevel2: json['subLocalityLevel2'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel2'])
          : null,
      subLocalityLevel3: json['subLocalityLevel3'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel3'])
          : null,
      subLocalityLevel4: json['subLocalityLevel4'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel4'])
          : null,
      subLocalityLevel5: json['subLocalityLevel5'] != null
          ? AddressComponent.fromJson(json['subLocalityLevel5'])
          : null,
    );
  }
}
