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
