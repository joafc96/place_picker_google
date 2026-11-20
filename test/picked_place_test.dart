import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/src/entities/address_component.dart';
import 'package:place_picker_google/src/entities/auto_complete_item.dart';
import 'package:place_picker_google/src/entities/location_result.dart';
import 'package:place_picker_google/src/utils/picked_place.dart';

void main() {
  const latLng = LatLng(37.8044, -122.2712);

  AutoCompleteItem picked() => AutoCompleteItem()
    ..id = 'ChIJ-blue-bottle'
    ..text = 'Blue Bottle Coffee, Webster Street, Oakland, CA, USA'
    ..mainText = 'Blue Bottle Coffee'
    ..secondaryText = 'Webster Street, Oakland, CA, USA';

  LocationResult geocoded() => LocationResult(
    name: '300 Webster St',
    formattedAddress: '300 Webster St, Oakland, 94607, United States',
    latLng: const LatLng(37.80441, -122.27119),
    locality: const AddressComponent(longName: 'Oakland', shortName: 'Oakland'),
  );

  group('pickedPlaceResult', () {
    test('keeps the picked place name and the Place Details address', () {
      final result = pickedPlaceResult(
        latLng: latLng,
        picked: picked(),
        geocoded: geocoded(),
        formattedAddress: '300 Webster St, Oakland, CA 94607, USA',
      );
      expect(result.name, 'Blue Bottle Coffee');
      expect(result.formattedAddress, '300 Webster St, Oakland, CA 94607, USA');
      expect(result.placeId, 'ChIJ-blue-bottle');
      expect(result.latLng, latLng);
    });

    test('keeps the geocoded address components', () {
      final result = pickedPlaceResult(
        latLng: latLng,
        picked: picked(),
        geocoded: geocoded(),
      );
      expect(result.locality?.longName, 'Oakland');
    });

    test('falls back to the suggestion text without a Details address', () {
      final result = pickedPlaceResult(
        latLng: latLng,
        picked: picked(),
        geocoded: geocoded(),
        formattedAddress: '  ',
      );
      expect(
        result.formattedAddress,
        'Blue Bottle Coffee, Webster Street, Oakland, CA, USA',
      );
    });

    test('still yields a result when reverse geocoding found nothing', () {
      final result = pickedPlaceResult(
        latLng: latLng,
        picked: picked(),
        formattedAddress: '300 Webster St, Oakland, CA 94607, USA',
      );
      expect(result.name, 'Blue Bottle Coffee');
      expect(result.latLng, latLng);
    });

    test('uses the geocoded name when the suggestion has no main text', () {
      final item = picked()..mainText = null;
      final result = pickedPlaceResult(
        latLng: latLng,
        picked: item,
        geocoded: geocoded(),
      );
      expect(result.name, '300 Webster St');
    });
  });
}
