## [0.3.2] - 20 Nov 2026
* Free geocoding (`useFreeGeocoding`) names places the same way on Android and iOS. Android's geocoder returns the whole address as the street and the house number as the name, so a map tap, pin drag or my location read "100" / "100 W 1st St, Los Angeles, CA 90012, USA, Los Angeles, 90012, United States"; it now reads "100 W 1st St" / "100 W 1st St, Los Angeles, CA 90012, USA". On iOS the address gains the state ("312 S Hill St, Los Angeles, CA 90013, United States") and a place's own name is kept. A name that is empty or only a number becomes the street line.
* With no `initialLocation` and the device location unavailable (permission denied, location off or no fix), the picker opens zoomed out on `PlacePicker.defaultLocation` with no place selected, and the select button stays disabled until the user searches, taps the map or moves the pin. It used to select the default location as if the user were there. A failed my location keeps the current selection.
* With no place selected the card shows `LocalizationConfig.unnamedLocation` once (it was shown as both the name and the address), and a place without an address (open water) shows no address line (it showed "null" with Google geocoding).

## [0.3.1] - 20 Nov 2026
* A place picked from the autocomplete list keeps its own name (the suggestion's main text) and address (the Place Details `formattedAddress`, else the suggestion's full text). Reverse geocoding used to replace both with the nearest street ("300 Webster St" for "Blue Bottle Coffee"), with either geocoding mode. The geocoded address components are kept, and a pick still yields a result when reverse geocoding finds nothing. Tapping the map, dragging the pin or "my location" still name the place by reverse geocoding.

## [0.3.0] - 18 Nov 2026
* **Breaking:** migrated from the SDK design libraries (`package:flutter/material.dart`, `package:flutter/cupertino.dart`) to the `material_ui` (^1.11.1) and `cupertino_ui` (^1.1.7) packages. The host app must also be on `material_ui` (its `MaterialApp`/`Theme`, and the `ButtonStyle` / `InputDecoration` values passed in the configs); apps still on the SDK libraries should stay on 0.2.0.

## [0.2.0] - 18 Nov 2026
* **Breaking:** minimum Flutter is now 3.47.0 (Dart 3.13).
* Updated `geocoding` version from 4.0.0 to 5.0.1 (`geocoding_darwin` replaces `geocoding_ios`); free geocoding now goes through the `Geocoding()` instance API.
* Updated `google_maps_flutter` version from 2.12.3 to 2.19.0. `PlacePicker.cloudMapId` keeps its name and is forwarded to `GoogleMap.mapId` (`GoogleMap.cloudMapId` is deprecated).
* Fixed `use_build_context_synchronously` in the location-services dialog (now guarded by the dialog's own `context.mounted`).
* Fixed sources for the Dart 3.13 language version (`final` parameter modifier, initializing formals).
* Example now declares its `google_maps_flutter` dependency.

## [0.1.0] - 11 May 2026
* **Breaking:** migrated from the legacy Places API to **Places API (New)**: autocomplete (`POST places:autocomplete`), nearby search (`POST places:searchNearby`) and place details (`GET places/{id}`). "Places API (New)" must be enabled for the API key. The Geocoding API call is unchanged.
* The API key is now sent in the `X-Goog-Api-Key` header and fields are selected with `X-Goog-FieldMask`.
* Fixed nearby place icons rendering as black silhouettes.
* Added unit tests for the Places service layer.

## [0.0.21] - 04 Aug 2025
* Updated http version from 1.4.0 to 1.5.0.
* Updated google entities to have const constructors.
* Organised config models to separate config directory.
* Updated README.md

## [0.0.20] - 04 Aug 2025
* Added political attribute. @samfzb
* Updated _reverseGeocodeLatLng method.
* Added geocoding package to use the free Geocoding services provided by the iOS and Android platforms. @giorgio79
* A new boolean flag `useFreeGeocoding` in the PlacePicker widget, so user could use free geocoding if required. @giorgio79
* Updated Readme

## [0.0.19] - 23 Jul 2025
* Updated geolocator version from 14.0.0 to 14.0.2
* Updated google_maps_flutter version from 2.12.2 to 2.12.3
* Updated INVALID_REQUEST error from Places API due to incorrect location format @Domenic-MZS
* searchbar does not respond to picking action @VOIDCRUSHER

## [0.0.18] - 23 May 2025
* Updated `geolocator` version from 13.0.4 to 14.0.0

## [0.0.17] - 23 May 2025

* Updated `google_maps_flutter` version from 2.11.0 to 2.12.2
* Updated `geolocator` version from 13.0.3 to 13.0.4
* Updated `http` version from 1.3.0 to 1.4.0
* Added `nearbyPlace` to `LocationResult` @stact
* Updated `name` in `LocationResult` when a nearbyPlace is selected @stact
* Added builder method for back button widget `BackWidgetBuilder`
* Added `cloudMapId` and other fields
* Separated common API services to `GoogleMapsCommonService`
* Added `GoogleAPIParameters` that can be added as optional params for different Maps APIs @Mithunms1234

## [0.0.16] - 23 Apr 2025

* Handled ZERO_RESULTS gracefully for autoCompleteSearch. @giorgio79
* Added `zoomControlsEnabled` and some other Google Maps property. @KD-Dhiren

## [0.0.15] - 25 Mar 2025

* Updated third party packages versions to the latest ones.
* Updated dart and flutter sdk versions.
* Added hero tag for floating action button.
* Added new administrative and sub locality levels.
* Added selected place config and updated selected place widget UI handling.

## [0.0.14] - 18 Dec 2024

* Added Logs/Future.Error for Errors from cloud console like Billing Not enabled or others. [#14](https://github.com/joafc96/place_picker_google/issues/14).
* Updated `SearchInputConfig` with `FocusNode`, `autofocus` etc

## [0.0.13] - 28 Nov 2024

* Added dart serialization `fromJson` and `toJson` to `LocationResult` & `AddressComponent` [#11](https://github.com/joafc96/place_picker_google/issues/11).

## [0.0.12] - 22 Nov 2024

* Added `MapType` to support different types of map.
* Updated minimum supported SDK version to Flutter 3.22.0 & Dart 3.4.0.
* Updated `google_maps_flutter` to 2.10.0.
* Updated `geolocator` to 13.0.2.

## [0.0.11] - 09 Oct 2024

* Bumped up the versions of third party packages used (`http`, `google_maps_flutter`, & `geolocator`).
* Updated the flutter and dart sdk versions.
* Removed `timeLimit: const Duration(seconds: 30)` from `getCurrentPosition` method of `geolocator` package.

## [0.0.10] - 26 Sep 2024

* Updated background color of auto place suggestions to `Theme.of(context).canvasColor`.

## [0.0.9] - 11 Sep 2024

* Exposed `mapsBaseUrl` in the package so web users can use a proxy server to adding necessary headers.
* Exposed `mapsHttpClient` in the package so users can provide their own http client.
* Exposed `mapsApiHeaders` in the package so users can provide their own http headers.
* Abstracted networking code out from the main package.
* Fixed infinite loop caused due to `animateCamera` and `onCameraMove` callback.
* Added new prop `autocompletePlacesSearchRadius` to narrow down the autocomplete search results to current location by providing radius in meters if needed.

## [0.0.8] - 08 Sep 2024

* Created dart classes for geocoding api results to make the code null safe and concise.
* Updated the logic to fetch and convert the json to dart classes. 
* Added `route` and `streetNumber` as fields in `LocalizationResult`.

## [0.0.7] - 01 Sep 2024

* Downgraded third party versions due to conflicts.
* Added camera animation zoom level as an internal state for real time zoom updates.
* Added `usePinPointingSearch` for toggling between tap selection and pin point (dragging) selection.
* Removed all platform specific code from `io`. 
* Added `SearchingState` to `SelectedPlaceWidgetBuilder` so user can update the builder according to `searching` and `idle` state.
* Removed `Uuid` third party package used for `sessionToken` generation.

## [0.0.6] - 17 Aug 2024

* Added `Web` support.
* Removed platform specific code.
* Breaking change: Updated `showNearbyPlaces` to `enableNearbyPlaces`.

## [0.0.5] - 17 Aug 2024

* Added `SearchInputConfig` & `SearchInputDecorationConfig` to help update the UI of `Search Input` if required.
* Added `My Location Button`, so users can easily navigate to their current location. 
* Added `MyLocationFABConfig` to help update the UI of `myLocationButton`.

## [0.0.4] - 16 Aug 2024

* Updated `LocationResult` object with correct `AddressComponents`.

## [0.0.3] - 15 Aug 2024

* Updated Dart version constraints.

## [0.0.2] - 15 Aug 2024

* Updated README.

## [0.0.1] - 15 Aug 2024

* Initial release with logic, widget and example.
