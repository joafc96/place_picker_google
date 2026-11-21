import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:place_picker_google/src/utils/device_placemark.dart';

void main() {
  /// Android: the street is the whole first address line and the name is the
  /// house number.
  const android = Placemark(
    name: '100',
    street: '100 W 1st St, Los Angeles, CA 90012, USA',
    subThoroughfare: '100',
    thoroughfare: 'West 1st Street',
    locality: 'Los Angeles',
    administrativeArea: 'California',
    postalCode: '90012',
    country: 'United States',
    isoCountryCode: 'US',
  );

  /// iOS: the street is the street line only and the name is the place's.
  const ios = Placemark(
    name: 'Grand Central Market',
    street: '312 S Hill St',
    subThoroughfare: '312',
    thoroughfare: 'S Hill St',
    locality: 'Los Angeles',
    administrativeArea: 'CA',
    postalCode: '90013',
    country: 'United States',
    isoCountryCode: 'US',
  );

  group('placemarkAddress', () {
    test('Android: the address line as is, without repeated parts', () {
      expect(
        placemarkAddress(android, platform: TargetPlatform.android),
        '100 W 1st St, Los Angeles, CA 90012, USA',
      );
    });

    test('iOS: street, locality, state with postal code, country', () {
      expect(
        placemarkAddress(ios, platform: TargetPlatform.iOS),
        '312 S Hill St, Los Angeles, CA 90013, United States',
      );
    });

    test('Android without an address line builds it from the parts', () {
      const placemark = Placemark(
        locality: 'Los Angeles',
        administrativeArea: 'California',
        postalCode: '90012',
        country: 'United States',
      );
      expect(
        placemarkAddress(placemark, platform: TargetPlatform.android),
        'Los Angeles, California 90012, United States',
      );
    });

    test('skips empty and repeated parts', () {
      const placemark = Placemark(
        street: '1 Fullerton Rd',
        locality: 'Singapore',
        administrativeArea: ' ',
        postalCode: '',
        country: 'Singapore',
      );
      expect(
        placemarkAddress(placemark, platform: TargetPlatform.iOS),
        '1 Fullerton Rd, Singapore',
      );
    });

    test('empty without any part (open water)', () {
      const placemark = Placemark(name: 'North Pacific Ocean');
      expect(placemarkAddress(placemark, platform: TargetPlatform.iOS), '');
      expect(placemarkAddress(placemark, platform: TargetPlatform.android), '');
    });
  });

  group('placemarkName', () {
    test('Android: a house-number name becomes the street line', () {
      expect(
        placemarkName(android, platform: TargetPlatform.android),
        '100 W 1st St',
      );
    });

    test("iOS: keeps the place's own name", () {
      expect(
        placemarkName(ios, platform: TargetPlatform.iOS),
        'Grand Central Market',
      );
    });

    test('a name with no letters (a postal code) becomes the street line', () {
      const placemark = Placemark(
        name: '94043',
        street: '1600 Amphitheatre Pkwy',
      );
      expect(
        placemarkName(placemark, platform: TargetPlatform.iOS),
        '1600 Amphitheatre Pkwy',
      );
    });

    test('an empty name becomes the street number and thoroughfare', () {
      const placemark = Placemark(
        name: ' ',
        subThoroughfare: '1600',
        thoroughfare: 'Amphitheatre Parkway',
      );
      expect(
        placemarkName(placemark, platform: TargetPlatform.android),
        '1600 Amphitheatre Parkway',
      );
    });

    test('keeps a numeric name when there is no street to use', () {
      const placemark = Placemark(name: '100');
      expect(placemarkName(placemark, platform: TargetPlatform.android), '100');
    });

    test('null without a name or a street', () {
      expect(
        placemarkName(const Placemark(), platform: TargetPlatform.android),
        isNull,
      );
    });
  });
}
