## [0.0.7] - 30 Aug 2024

* Downgraded third party versions due to conflicts.
* Added camera animation zoom level as an internal state for real time zoom updates.
* Added `usePinPointingSearch` for toggling between tap selection and pin point (dragging) selection.
* Removed all platform specific code from `io`. 
* Added `SearchingState` to `SelectedPlaceWidgetBuilder` so user can update the builder according to `searching` and `idle` state.

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
