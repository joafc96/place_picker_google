import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:place_picker_google/place_picker_google.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await FlutterConfig.loadEnvVariables();
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Place Picker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GooglePlacePickerExample(),
    );
  }
}

class GooglePlacePickerExample extends StatefulWidget {
  const GooglePlacePickerExample({super.key});

  @override
  State<GooglePlacePickerExample> createState() =>
      _GooglePlacePickerExampleState();
}

class _GooglePlacePickerExampleState extends State<GooglePlacePickerExample> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Pick Delivery location"),
          onPressed: () {
            showPlacePicker();
          },
        ),
      ),
    );
  }

  void showPlacePicker() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            baseUrl: kIsWeb
                ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
                : "https://maps.googleapis.com/maps/api/",
            usePinPointingSearch: true,
            apiKey: kIsWeb
                ? "GOOGLE_API_KEY"
                : Platform.isAndroid
                    ? FlutterConfig.get('GOOGLE_MAPS_API_KEY_ANDROID')
                    : FlutterConfig.get('GOOGLE_MAPS_API_KEY_IOS'),
            onPlacePicked: (LocationResult result) {
              debugPrint("Place picked: ${result.formattedAddress}");
              Navigator.of(context).pop();
            },
            enableNearbyPlaces: false,
            showSearchInput: true,
            initialLocation: const LatLng(
              29.378586,
              47.990341,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;
            },
            searchInputConfig: const SearchInputConfig(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              autofocus: false,
              textDirection: TextDirection.ltr,
            ),
            searchInputDecorationConfig: const SearchInputDecorationConfig(
              hintText: "Search for a building, street or ...",
            ),
            // selectedPlaceWidgetBuilder: (ctx, state, result) {
            //   return const SizedBox.shrink();
            // },
          );
        },
      ),
    );
  }
}
