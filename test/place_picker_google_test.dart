import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

void main() {
  testWidgets('PlacePicker has a useFreePlacemarkService flag',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlacePicker(
          apiKey: 'test_api_key',
          initialLocation: const LatLng(0, 0),
          useFreePlacemarkService: true,
        ),
      ),
    );

    final placePicker = tester.widget<PlacePicker>(find.byType(PlacePicker));
    expect(placePicker.useFreePlacemarkService, isTrue);
  });
}
