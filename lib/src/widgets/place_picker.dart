import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:place_picker_google/src/entities/index.dart';
import 'package:place_picker_google/src/entities/search_input_config.dart';
import 'package:place_picker_google/src/widgets/index.dart';
import 'package:uuid/uuid.dart';

import 'dart:io' show Platform;

typedef SelectPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  LocationResult? selectedPlace,
);

/// Google place picker widget made with map widget from
/// [google_maps_flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter)
/// and other API calls to [Google Places API](https://developers.google.com/places/web-service/intro)
///
/// API key provided should have `Maps SDK for Android`,
/// `Maps SDK for iOS` and `Places API`  enabled for it
class PlacePicker extends StatefulWidget {
  static const LatLng defaultLocation = LatLng(37.4219983, -122.084);

  /// API key generated from Google Cloud Console. You can get an API key
  /// [here](https://cloud.google.com/maps-platform/)
  final String apiKey;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// Location to be displayed when screen is showed. If this is set or not null, the
  /// map does not pan to the user's current location.
  final LatLng? initialLocation;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Builder method for s
  final SelectPlaceWidgetBuilder? selectPlaceWidgetBuilder;

  /// Localization Config for passing localized values
  final LocalizationConfig localizationConfig;

  /// Callback with `LocationResult` for when user clicks the confirm button
  final ValueChanged<LocationResult>? onPlacePicked;

  /// Search Input
  final bool showSearchInput;
  final SearchInputConfig searchInputConfig;
  final SearchInputDecorationConfig searchInputDecorationConfig;

  /// Nearby Places
  final TextStyle? nearbyPlaceItemStyle;
  final TextStyle? nearbyPlaceStyle;
  final bool showNearbyPlaces;

  /// Select Place
  final TextStyle? selectLocationNameStyle;
  final TextStyle? selectFormattedAddressStyle;
  final Widget? selectActionButtonChild;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  const PlacePicker({
    super.key,
    required this.apiKey,
    this.onMapCreated,
    this.initialLocation,
    this.onPlacePicked,
    this.minMaxZoomPreference = const MinMaxZoomPreference(0, 16),
    this.localizationConfig = const LocalizationConfig.init(),
    this.showSearchInput = true,
    this.searchInputConfig = const SearchInputConfig(),
    this.searchInputDecorationConfig = const SearchInputDecorationConfig(),
    this.showNearbyPlaces = true,
    this.nearbyPlaceItemStyle,
    this.nearbyPlaceStyle,
    this.selectLocationNameStyle,
    this.selectFormattedAddressStyle,
    this.selectPlaceWidgetBuilder,
    this.selectActionButtonChild,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
  });

  @override
  State<StatefulWidget> createState() => PlacePickerState();
}

/// Place picker state
class PlacePickerState extends State<PlacePicker>
    with TickerProviderStateMixin {
  final Completer<GoogleMapController> mapController = Completer();

  /// Current location of the marker
  LatLng? _currentLocation;

  /// Flag to toggle whether map can be shown or not
  bool _canLoadMap = false;

  /// Indicator for the selected location
  final Set<Marker> markers = {};

  /// Result returned after user completes selection
  LocationResult? locationResult;

  /// Overlay to display autocomplete suggestions
  OverlayEntry? _suggestionsOverlayEntry;

  /// List to populate nearby places from places api
  List<NearbyPlace> nearbyPlaces = [];

  /// Session token required for autocomplete API call
  String sessionToken = const Uuid().v4();

  /// To find the render box of search input
  GlobalKey searchInputKey = GlobalKey(debugLabel: "__search_input_box__");

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  /// Unique link used for composited target and follower
  final _layerLink = LayerLink();

  /// On map created
  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    moveToCurrentUserLocation();

    /// invoke the `onMapCreated` callback
    widget.onMapCreated?.call(controller);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _initializeMarkers();
    super.initState();
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _initializeMarkers() async {
    if (widget.initialLocation == null) {
      try {
        final LatLng position = await _getCurrentLocation();
        setState(() {
          _currentLocation = position;
        });
        setState(() {
          _canLoadMap = true;
        });
      } catch (e) {
        if (e is LocationServiceDisabledException) {
          if (mounted) Navigator.of(context).pop();
        } else {
          setState(() {
            _canLoadMap = true;
          });
        }
        debugPrint(e.toString());
      }
    } else {
      setState(() {
        markers.add(
          Marker(
            position: widget.initialLocation!,
            markerId: const MarkerId("selected-location"),
          ),
        );
        _canLoadMap = true;
      });
    }
  }

  /// Method to hide the suggestions overlay
  void _hideOverlay() {
    _suggestionsOverlayEntry?.remove();
    _suggestionsOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: !_canLoadMap
              ? Center(
                  child: Platform.isAndroid
                      ? const CircularProgressIndicator()
                      : const CupertinoActivityIndicator(),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: widget.initialLocation ??
                            _currentLocation ??
                            PlacePicker.defaultLocation,
                        zoom: _currentLocation == null &&
                                widget.initialLocation == null
                            ? 4
                            : 16,
                      ),
                      minMaxZoomPreference: widget.minMaxZoomPreference,
                      myLocationEnabled: widget.myLocationEnabled,
                      onMapCreated: onMapCreated,
                      onTap: (latLng) {
                        _clearOverlay();
                        moveToLocation(latLng);
                      },
                      markers: markers,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: true,
                    ),

                    /// Search Input
                    if (widget.showSearchInput)
                      SafeArea(
                        child: Padding(
                          padding: widget.searchInputConfig.padding ??
                              EdgeInsets.zero,
                          child: CompositedTransformTarget(
                            link: _layerLink,
                            child: SearchInput(
                              key: searchInputKey,
                              inputConfig: widget.searchInputConfig,
                              onSearchInput: searchPlace,
                              decorationConfig:
                                  widget.searchInputDecorationConfig,
                            ),
                          ),
                        ),
                      ),

                    if (widget.myLocationButtonEnabled)
                      _buildMyLocationButton(),
                  ],
                ),
        ),

        /// Select Place
        if (!hasSearchTerm) _buildSelectPlace(),

        /// Nearby Places
        if (!hasSearchTerm && widget.showNearbyPlaces)
          NearbyPlaces(
            moveToLocation: moveToLocation,
            nearbyPlaces: nearbyPlaces,
            nearbyPlaceText: widget.localizationConfig.nearBy,
            nearbyPlaceStyle: widget.nearbyPlaceStyle,
            nearbyPlaceItemStyle: widget.nearbyPlaceItemStyle,
          ),
      ],
    );
  }

  /// My Location Widget
  Widget _buildMyLocationButton() {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: FloatingActionButton(
        mini: true,
        onPressed: _locateMe,
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }

  /// Selected Place Widget
  Widget _buildSelectPlace() {
    if (widget.selectPlaceWidgetBuilder == null) {
      return SafeArea(
        top: false,
        bottom: !widget.showNearbyPlaces,
        child: SelectPlaceAction(
          locationName: getLocationName(),
          formattedAddress: getFormattedLocationName(),
          onTap: locationResult != null
              ? () {
                  widget.onPlacePicked?.call(locationResult!);
                }
              : null,
          actionText: widget.localizationConfig.selectActionLocation,
          locationNameStyle: widget.selectLocationNameStyle,
          formattedAddressStyle: widget.selectFormattedAddressStyle,
          actionChild: widget.selectActionButtonChild,
        ),
      );
    } else {
      return Builder(
        builder: (ctx) => widget.selectPlaceWidgetBuilder!(ctx, locationResult),
      );
    }
  }

  /// Hides the autocomplete overlay
  void _clearOverlay() async {
    if (_suggestionsOverlayEntry != null) {
      _suggestionsOverlayEntry?.remove();
      _suggestionsOverlayEntry = null;
    }
  }

  /// Callback if user has enabled [myLocationButtonEnabled].
  /// Function will animate the camera to current location, given user has provided
  /// permission for location access.
  Future<void> _locateMe() async {
    try {
      final LatLng position = await _getCurrentLocation();
      moveToLocation(position);
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        if (mounted) Navigator.of(context).pop();
      }
      debugPrint(e.toString());
    }
  }

  /// Begins the search process by displaying a "wait" overlay then
  /// proceeds to fetch the autocomplete list. The bottom "dialog"
  /// is hidden so as to give more room and better experience for the
  /// autocomplete list overlay.
  void searchPlace(String place) {
    /// on keyboard dismissal, the search was being triggered again
    /// this is to cap that.
    if (place == previousSearchTerm) {
      return;
    }

    previousSearchTerm = place;

    _clearOverlay();

    setState(() {
      hasSearchTerm = place.isNotEmpty;
    });

    if (place.isEmpty) {
      return;
    }

    final RenderBox? searchInputBox =
        searchInputKey.currentContext?.findRenderObject() as RenderBox?;

    _suggestionsOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: searchInputBox?.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, searchInputBox?.size.height ?? 0),
          showWhenUnlinked: false,
          child: Material(
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Platform.isAndroid
                        ? const CircularProgressIndicator()
                        : const CupertinoActivityIndicator(),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      widget.localizationConfig.findingPlace,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    /// Insert the finding places in suggestions overlay entry
    Overlay.of(context).insert(_suggestionsOverlayEntry!);

    autoCompleteSearch(place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String place) async {
    try {
      place = place.replaceAll(" ", "+");

      var endpoint =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
          "key=${widget.apiKey}&"
          "language=${widget.localizationConfig.languageCode}&"
          "input={$place}&sessiontoken=$sessionToken";

      if (locationResult != null) {
        endpoint += "&location=${locationResult!.latLng?.latitude},"
            "${locationResult!.latLng?.longitude}";
      }

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['predictions'] == null) {
        throw Error();
      }

      List<dynamic> predictions = responseJson['predictions'];

      List<RichSuggestion> suggestions = [];

      if (predictions.isEmpty) {
        AutoCompleteItem aci = AutoCompleteItem();
        aci.text = widget.localizationConfig.noResultsFound;
        aci.offset = 0;
        aci.length = 0;

        suggestions.add(
          RichSuggestion(
            autoCompleteItem: aci,
          ),
        );
      } else {
        for (dynamic t in predictions) {
          final aci = AutoCompleteItem()
            ..id = t['place_id']
            ..text = t['description']
            ..offset = t['matched_substrings'][0]['offset']
            ..length = t['matched_substrings'][0]['length'];

          suggestions.add(
            RichSuggestion(
              autoCompleteItem: aci,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                decodeAndSelectPlace(aci.id!);
              },
            ),
          );
        }
      }

      displayAutoCompleteSuggestions(suggestions);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox? searchInputBox =
        searchInputKey.currentContext?.findRenderObject() as RenderBox?;

    _clearOverlay();

    _suggestionsOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: searchInputBox?.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, searchInputBox?.size.height ?? 0),
          child: Material(
            elevation: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: suggestions,
            ),
          ),
        ),
      ),
    );

    /// Insert the suggestions overlay
    Overlay.of(context).insert(_suggestionsOverlayEntry!);
  }

  /// To navigate to the selected place from the autocomplete list to the map,
  /// the lat,lng is required. This method fetches the lat,lng of the place and
  /// proceeds to moving the map to that location.
  void decodeAndSelectPlace(String placeId) async {
    _clearOverlay();

    try {
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/details/json?key=${widget.apiKey}&language=${widget.localizationConfig.languageCode}&placeid=$placeId");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['result'] == null) {
        throw Error();
      }

      final location = responseJson['result']['geometry']['location'];
      if (mapController.isCompleted) {
        await moveToLocation(LatLng(location['lat'], location['lng']));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Utility function to get clean readable name of a location. First checks
  /// for a human-readable name from the nearby list. This helps in the cases
  /// that the user selects from the nearby list (and expects to see that as a
  /// result, instead of road name). If no name is found from the nearby list,
  /// then the road name returned is used instead.
  String getLocationName() {
    if (locationResult == null) {
      return widget.localizationConfig.unnamedLocation;
    }

    for (NearbyPlace np in nearbyPlaces) {
      if (np.latLng == locationResult?.latLng &&
          np.name != locationResult?.locality?.shortName) {
        locationResult?.name = np.name;
        return "${np.name}, ${locationResult?.locality}";
      }
    }

    return "${locationResult?.name}";
  }

  /// Utility function to get clean readable formatted address of a location.
  String getFormattedLocationName() {
    if (locationResult == null) {
      return widget.localizationConfig.unnamedLocation;
    }

    return "${locationResult?.formattedAddress}";
  }

  /// Moves the marker to the indicated lat,lng
  void setMarker(LatLng latLng) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("selected-location"),
          position: latLng,
        ),
      );
    });
  }

  /// Fetches and updates the nearby places to the provided lat,lng
  Future<void> getNearbyPlaces(LatLng latLng) async {
    try {
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
          "key=${widget.apiKey}&location=${latLng.latitude},${latLng.longitude}"
          "&radius=150&language=${widget.localizationConfig.languageCode}");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      nearbyPlaces.clear();

      for (Map<String, dynamic> item in responseJson['results']) {
        final nearbyPlace = NearbyPlace()
          ..name = item['name']
          ..icon = item['icon']
          ..latLng = LatLng(item['geometry']['location']['lat'],
              item['geometry']['location']['lng']);

        nearbyPlaces.add(nearbyPlace);
      }

      /// to update the nearby places
      setState(() {
        /// this is to require the result to show
        hasSearchTerm = false;
      });
    } catch (e) {
      ///
    }
  }

  /// This method gets the human readable name of the location. Mostly appears
  /// to be the road name and the locality.
  Future<void> reverseGeocodeLatLng(LatLng latLng) async {
    try {
      final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?"
          "latlng=${latLng.latitude},${latLng.longitude}&"
          "language=${widget.localizationConfig.languageCode}&"
          "key=${widget.apiKey}");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      final result = responseJson['results'][0];

      setState(
        () {
          String name = "";
          String? localityShortName,
              postalCodeShortName,
              plusCodeShortName,
              countryShortName,
              administrativeAreaLevel1ShortName,
              administrativeAreaLevel2ShortName,
              subLocalityLevel1ShortName,
              subLocalityLevel2ShortName;

          String? localityLongName,
              postalCodeLongName,
              plusCodeLongName,
              countryLongName,
              administrativeAreaLevel1LongName,
              administrativeAreaLevel2LongName,
              subLocalityLevel1LongName,
              subLocalityLevel2LongName;
          bool isOnStreet = false;
          if (result['address_components'] is List<dynamic> &&
              result['address_components'].length != null &&
              result['address_components'].length > 0) {
            for (var i = 0; i < result['address_components'].length; i++) {
              var tmp = result['address_components'][i];
              var types = tmp["types"] as List<dynamic>;

              /// `short` and `long` names from google api
              var shortName = tmp['short_name'];
              var longName = tmp['long_name'];

              if (i == 0) {
                /// [street_number]
                name = shortName;
                isOnStreet = types.contains('street_number');

                /// other index 0 types
                /// [establishment, point_of_interest, subway_station, transit_station]
                /// [premise]
                /// [route]
              } else if (i == 1 && isOnStreet) {
                if (types.contains('route')) {
                  name += ", $shortName";
                }
              } else {
                if (types.contains("country")) {
                  countryLongName = longName;
                  countryShortName = shortName;
                } else if (types.contains("locality")) {
                  localityLongName = longName;
                  localityShortName = shortName;
                } else if (types.contains("sublocality_level_1")) {
                  subLocalityLevel1LongName = longName;
                  subLocalityLevel1ShortName = shortName;
                } else if (types.contains("sublocality_level_2")) {
                  subLocalityLevel2LongName = longName;
                  subLocalityLevel2ShortName = shortName;
                } else if (types.contains("administrative_area_level_1")) {
                  administrativeAreaLevel1LongName = longName;
                  administrativeAreaLevel1ShortName = shortName;
                } else if (types.contains("administrative_area_level_2")) {
                  administrativeAreaLevel2LongName = longName;
                  administrativeAreaLevel2ShortName = shortName;
                } else if (types.contains('postal_code')) {
                  postalCodeLongName = longName;
                  postalCodeShortName = shortName;
                } else if (types.contains('plus_code')) {
                  plusCodeLongName = longName;
                  plusCodeShortName = shortName;
                }
              }
            }
          }

          locationResult = LocationResult()
            ..name = name
            ..latLng = latLng
            ..formattedAddress = result['formatted_address']
            ..placeId = result['place_id']
            ..country = AddressComponent(
              longName: countryLongName,
              shortName: countryShortName,
            )
            ..locality = AddressComponent(
              longName: localityLongName ?? administrativeAreaLevel1LongName,
              shortName: localityShortName ?? administrativeAreaLevel1ShortName,
            )
            ..administrativeAreaLevel1 = AddressComponent(
              longName: administrativeAreaLevel1LongName,
              shortName: administrativeAreaLevel1ShortName,
            )
            ..administrativeAreaLevel2 = AddressComponent(
              longName: administrativeAreaLevel2LongName,
              shortName: administrativeAreaLevel2ShortName,
            )
            ..subLocalityLevel1 = AddressComponent(
              longName: subLocalityLevel1LongName,
              shortName: subLocalityLevel1ShortName,
            )
            ..subLocalityLevel2 = AddressComponent(
              longName: subLocalityLevel2LongName,
              shortName: subLocalityLevel2ShortName,
            )
            ..postalCode = AddressComponent(
              longName: postalCodeLongName,
              shortName: postalCodeShortName,
            )
            ..plusCode = AddressComponent(
              longName: plusCodeLongName,
              shortName: plusCodeShortName,
            );
        },
      );

      /// if show nearby places flag is false, re-build the app here,
      /// as nearby api wont be called
      if (!widget.showNearbyPlaces) {
        setState(() {
          hasSearchTerm = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Moves the camera to the provided location and updates other UI features to
  /// match the location.
  Future<void> moveToLocation(LatLng latLng) async {
    final controller = await mapController.future;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 16.0,
        ),
      ),
    );

    /// Set Marker
    setMarker(latLng);

    /// Reverse Geocode Lat Lng
    reverseGeocodeLatLng(latLng);

    if (widget.showNearbyPlaces) getNearbyPlaces(latLng);
  }

  void moveToCurrentUserLocation() async {
    if (widget.initialLocation != null) {
      moveToLocation(widget.initialLocation!);
    } else if (_currentLocation != null) {
      moveToLocation(_currentLocation!);
    } else {
      moveToLocation(PlacePicker.defaultLocation);
    }
  }

  /// Get current location API
  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      /// Location services are not enabled don't continue
      /// accessing the position and request users of the
      /// App to enable the location services.
      if (mounted) {
        final bool? isOk = await _showLocationDisabledAlertDialog(context);
        if (isOk ?? false) {
          return Future.error(const LocationServiceDisabledException());
        } else {
          return Future.error('Location Services is not enabled');
        }
      }
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        /// Permissions are denied, next time you could try
        /// requesting permissions again (this is also where
        /// Android's shouldShowRequestPermissionRationale
        /// returned true. According to Android guidelines
        /// your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      /// Permissions are denied forever, handle appropriately.
      /// return widget.defaultLocation;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    try {
      final locationData = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 30),
      );
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      debugPrint('target:$target');
      return target;
    } on TimeoutException catch (_) {
      final locationData = await Geolocator.getLastKnownPosition();
      if (locationData != null) {
        return LatLng(locationData.latitude, locationData.longitude);
      } else {
        return PlacePicker.defaultLocation;
      }
    }
  }

  Future<dynamic> _showLocationDisabledAlertDialog(BuildContext context) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text("Location is disabled"),
              content: const Text(
                  "To use location, go to your Settings App > Privacy > Location Services."),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          });
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Location is disabled"),
            content: const Text(
                "The app needs to access your location. Please enable location service."),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  await Geolocator.openLocationSettings().then((value) {
                    if (mounted) Navigator.of(context).pop(true);
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }
}

enum AddressComponentTypes {
  plusCode,
  locality,
  subLocality,
  subLocality1,
  subLocality2,
  postalCode,
  country,
  administrativeAreaLevel1,
  administrativeAreaLevel2,
}
