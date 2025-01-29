import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:place_picker_google/place_picker_google.dart';
import 'package:place_picker_google/src/services/index.dart';
import 'package:place_picker_google/src/utils/index.dart';
import 'package:place_picker_google/src/entities/google/index.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  SearchingState state,
  LocationResult? selectedPlace,
);

typedef PinWidgetBuilder = Widget Function(
  BuildContext context,
  PinState state,
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

  /// Maps base url
  final String? mapsBaseUrl;

  /// Maps http client
  final http.Client? mapsHttpClient;

  /// Maps api headers
  final Map<String, String>? mapsApiHeaders;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// Type of map to be displayed
  ///
  /// Defaults to [MapType.normal]
  final MapType mapType;

  /// Location to be displayed when screen is showed. If this is set or not null, the
  /// map does not pan to the user's current location.
  final LatLng? initialLocation;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Localization Config for passing localized values
  final LocalizationConfig localizationConfig;

  /// Callback with `LocationResult` for when user clicks the confirm button
  final ValueChanged<LocationResult>? onPlacePicked;

  final Color? confirmBtnBgColor;

  final Color? confirmBtnTextColor;

  final TextStyle? confirmBtnTextStyle;

  /// Search Input
  final bool showSearchInput;
  final SearchInputConfig searchInputConfig;
  final SearchInputDecorationConfig searchInputDecorationConfig;

  /// Nearby Places
  final TextStyle? nearbyPlaceItemStyle;
  final TextStyle? nearbyPlaceStyle;
  final bool enableNearbyPlaces;

  /// Selected Place
  final TextStyle? selectedLocationNameStyle;
  final TextStyle? selectedFormattedAddressStyle;
  final Widget? selectedActionButtonChild;

  /// Builder method for selected place widget
  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;

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

  /// Config of my location FAB
  final MyLocationFABConfig myLocationFABConfig;

  /// The elevation provided for the autocomplete overlay.
  final double autoCompleteOverlayElevation;

  /// Whether to set the selection to tappable or scrollable
  final bool usePinPointingSearch;

  /// Places api call debounce time in milli seconds
  /// works only for [usePinPointingSearch] is enabled
  final int pinPointingDebounceDuration;

  /// Builder method for pinPointing Pin widget
  final PinWidgetBuilder? pinPointingPinWidgetBuilder;

  /// Radius in meters to narrow down the autocomplete places search results
  /// according to the current location
  final num? autocompletePlacesSearchRadius;

  const PlacePicker({
    super.key,
    required this.apiKey,
    this.mapsBaseUrl = 'https://maps.googleapis.com/maps/api/',
    this.mapsApiHeaders,
    this.mapsHttpClient,
    this.onMapCreated,
    this.initialLocation,
    this.onPlacePicked,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = const MinMaxZoomPreference(0, 16.0),
    this.localizationConfig = const LocalizationConfig.init(),
    this.showSearchInput = true,
    this.searchInputConfig = const SearchInputConfig(),
    this.searchInputDecorationConfig = const SearchInputDecorationConfig(),
    this.enableNearbyPlaces = true,
    this.nearbyPlaceItemStyle,
    this.nearbyPlaceStyle,
    this.selectedLocationNameStyle,
    this.selectedFormattedAddressStyle,
    this.selectedPlaceWidgetBuilder,
    this.selectedActionButtonChild,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.myLocationFABConfig = const MyLocationFABConfig(),
    this.autoCompleteOverlayElevation = 0,
    this.usePinPointingSearch = false,
    this.pinPointingDebounceDuration = 500,
    this.pinPointingPinWidgetBuilder,

    this.confirmBtnBgColor,
    this.confirmBtnTextColor,
    this.confirmBtnTextStyle,

    this.autocompletePlacesSearchRadius,

  });

  @override
  State<StatefulWidget> createState() => PlacePickerState();
}

/// Place picker state

class PlacePickerState extends State<PlacePicker>
    with TickerProviderStateMixin {
  /// Map Controller Completer
  final Completer<GoogleMapController> mapController = Completer();

  /// Google Place Picker Service
  late final googlePlacePickerService = GoogleMapsPlaces(
    apiKey: widget.apiKey,
    baseUrl: widget.mapsBaseUrl,
    httpClient: widget.mapsHttpClient,
    apiHeaders: widget.mapsApiHeaders,
  );

  /// Current location of the marker
  LatLng? _currentLocation;

  /// Flag to toggle whether map can be shown or not
  bool _canLoadMap = false;

  /// Indicator for the selected location
  final Set<Marker> markers = {};

  /// GeoCoding result returned after user completes selection
  LocationResult? _geocodingResult;

  /// GeoCoding results list for further use
  late final List<LocationResult> _geocodingResultList = [];

  /// Overlay to display autocomplete suggestions
  OverlayEntry? _suggestionsOverlayEntry;

  /// List to populate nearby places from places api
  List<NearbyPlace> nearbyPlaces = [];

  /// Session token required for autocomplete API call
  String sessionToken = Uuid().generateV4();

  /// To find the render box of search input
  GlobalKey searchInputKey = GlobalKey(debugLabel: "__search_input_box__");

  String previousSearchTerm = '';

  /// Unique link used for composited target and follower
  final _layerLink = LayerLink();

  /// initial zoom level
  late double _zoom = widget.minMaxZoomPreference.maxZoom ?? 16.0;

  /// debounce timer to stop unwanted places api calls
  Timer? _debounce;

  /// internal state to handle the pin
  PinState _pinState = PinState.preparing;

  /// internal state to handle the searching state
  SearchingState _searchingState = SearchingState.idle;

  /// simple getter to check whether searchingState is searching
  bool get isSearching => _searchingState == SearchingState.searching;

  /// To prevent infinite loop
  /// The onCameraIdle callback in Google Maps Flutter for Android,
  /// can be triggered infinitely if there is some unintended feedback loop in the code.
  bool _isAnimating = false;

  CameraPosition? cameraPosition;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _initializePositionAndMarkers();
    super.initState();
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _initializePositionAndMarkers() async {
    try {
      final LatLng position = widget.initialLocation ?? await _getCurrentLocation();

      if (mounted) {
        setState(() {
          _currentLocation = position;

          if (!widget.usePinPointingSearch && widget.initialLocation != null) {
            markers.add(
              Marker(
                position: widget.initialLocation!,
                markerId: const MarkerId("selected-location"),
              ),
            );
          }

          _canLoadMap = true;
        });
      }
    } catch (e) {
      if (e is LocationServiceDisabledException && mounted) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _canLoadMap = true;
        });
      }
      debugPrint(e.toString());
    }
  }

  /// Method to hide the suggestions overlay
  void _hideOverlay() {
    _suggestionsOverlayEntry?.remove();
    _suggestionsOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            child: _canLoadMap ? _buildMapContent() : _buildLoadingIndicator(),
          ),
          _buildSelectedPlace(),
          if (widget.enableNearbyPlaces) _buildNearbyPlaces(),
        ],
      ),
    );
  }

  Widget _buildMapContent() {
    return Stack(
      children: [
        _buildGoogleMap(),
        if (widget.showSearchInput) _buildSearchInput(),
        if (widget.myLocationButtonEnabled) _buildMyLocationButton(),
        if (widget.usePinPointingSearch) _buildPinPointingIndicator(),
      ],
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialLocation ?? _currentLocation ?? PlacePicker.defaultLocation,
        zoom: _getInitialZoom(),
      ),
      minMaxZoomPreference: widget.minMaxZoomPreference,
      myLocationEnabled: widget.myLocationEnabled,
      mapType: widget.mapType,
      onTap: onTap,
      markers: markers,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: true,
      onMapCreated: onMapCreated,
      onCameraIdle: onCameraIdle,
      onCameraMoveStarted: onCameraMoveStarted,
      onCameraMove: onCameraMove,
    );
  }

  double _getInitialZoom() {
    return (_currentLocation == null && widget.initialLocation == null) ? 4 : _zoom;
  }

  Widget _buildLoadingIndicator() {
    return Platform.isiOS ? const CupertinoActivityIndicator() : const Center(child: CircularProgressIndicator());
  }

  Widget _buildSearchInput() {
    return SafeArea(
      child: Padding(
        padding: widget.searchInputConfig.padding ?? EdgeInsets.zero,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: SearchInput(
            key: searchInputKey,
            inputConfig: widget.searchInputConfig,
            onSearchInput: searchPlace,
            decorationConfig: widget.searchInputDecorationConfig,
          ),
        ),
      ),
    );
  }

  Widget _buildPinPointingIndicator() {
    return Positioned.fill(
      child: UnconstrainedBox(
        child: FractionalTranslation(
          translation: const Offset(0, -0.5),
          child: _buildPinWidget(),
        ),
      ),
    );
  }

  /// Nearby Places
  Widget _buildNearbyPlaces() {
    return NearbyPlaces(
      moveToLocation: animateToLocation,
      nearbyPlaces: nearbyPlaces,
      nearbyPlaceText: widget.localizationConfig.nearBy,
      nearbyPlaceStyle: widget.nearbyPlaceStyle,
      nearbyPlaceItemStyle: widget.nearbyPlaceItemStyle,
    );
  }

  /// GOOGLE MAPS FLUTTER CALLBACKS
  /// On map created
  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    moveToCurrentUserLocation();

    if (widget.usePinPointingSearch) {
      setState(() {
        _pinState = PinState.idle;
        _searchingState = SearchingState.idle;
      });
    }

    /// invoke the `onMapCreated` callback
    widget.onMapCreated?.call(controller);
  }

  /// On Camera idle
  void onCameraIdle() {
    if (_isAnimating) return;

    /// if not pin pointing search
    /// set pin state as dragging and update and
    /// call the places API after the debounce is completed.
    if (widget.usePinPointingSearch &&
        _pinState == PinState.dragging &&
        cameraPosition != null) {
      _debouncePinPointing(cameraPosition!.target);
    }

    setState(() {
      _pinState = PinState.idle;
    });
  }

  /// On Camera move started
  void onCameraMoveStarted() {
    if (_isAnimating) return;

    setState(() {
      _pinState = PinState.dragging;
      if (widget.usePinPointingSearch) {
        _searchingState = SearchingState.searching;
      }
    });
  }

  /// On Camera move
  void onCameraMove(CameraPosition position) {
    if (_isAnimating) return;

    /// set current camera position
    /// when map is dragging
    cameraPosition = position;

    /// set zoom level
    _zoom = position.zoom;
  }

  /// On user taps map
  onTap(LatLng position) {
    if (!widget.usePinPointingSearch) {
      setState(() {
        _searchingState = SearchingState.searching;
      });
    }

    _clearOverlay();
    animateToLocation(position);
  }

  /// Debounce function for pin-pointing search
  void _debouncePinPointing(LatLng target) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: widget.pinPointingDebounceDuration), () {
      animateToLocation(target);
    });
  }

  /// My Location Widget
  Widget _buildMyLocationButton() {
    return Positioned(
      top: widget.myLocationFABConfig.top,
      bottom: widget.myLocationFABConfig.bottom ?? 8.0,
      right: widget.myLocationFABConfig.right ?? 8.0,
      left: widget.myLocationFABConfig.left,
      child: FloatingActionButton(
        shape: widget.myLocationFABConfig.shape,
        elevation: widget.myLocationFABConfig.elevation,
        mini: widget.myLocationFABConfig.mini,
        tooltip: widget.myLocationFABConfig.tooltip,
        backgroundColor: widget.myLocationFABConfig.backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: widget.myLocationFABConfig.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        onPressed: _locateMe,
        child: widget.myLocationFABConfig.child ?? const Icon(Icons.gps_fixed),
      ),
    );
  }

  /// Selected Place Widget
  Widget _buildSelectedPlace() {
    if (widget.selectedPlaceWidgetBuilder == null) {

      return locationResult != null
          ? SafeArea(
              top: false,
              bottom: !widget.enableNearbyPlaces,
              child: SelectPlaceWidget(
                locationName: getLocationName(),
                formattedAddress: getFormattedLocationName(),
                onTap: locationResult != null
                    ? () {
                        widget.onPlacePicked?.call(locationResult!);
                      }
                    : null,
                actionText: widget.localizationConfig.selectActionLocation,
                locationNameStyle: widget.selectedLocationNameStyle,
                formattedAddressStyle: widget.selectedFormattedAddressStyle,
                actionChild: widget.selectedActionButtonChild,
                confirmBtnBgColor: widget.confirmBtnBgColor,
                confirmBtnTextColor: widget.confirmBtnTextColor,
                confirmBtnTextStyle: widget.confirmBtnTextStyle,
              ),
            )
          : const SizedBox.shrink();

    } else {
      return Builder(
        builder: (ctx) => widget.selectedPlaceWidgetBuilder!(
          ctx,
          _searchingState,
          _geocodingResult,
        ),
      );
    }
  }

  /// Pin Widget for Pin point selection
  Widget _buildPinWidget() {
    if (widget.pinPointingPinWidgetBuilder == null) {
      return AnimatedPin(
        state: _pinState,
        child: const Icon(
          Icons.place,
          size: 40,
          color: Colors.red,
        ),
      );
    } else {
      return Builder(
        builder: (ctx) => widget.pinPointingPinWidgetBuilder!(ctx, _pinState),
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

  /// Begins the search process by displaying a "wait" overlay then
  /// proceeds to fetch the autocomplete list. The bottom "dialog"
  /// is hidden so as to give more room and better experience for the
  /// autocomplete list overlay.
  void searchPlace(String place) {
    /// on keyboard dismissal, the search was being triggered again
    /// this is to cap that.
    if (place == previousSearchTerm) return;

    previousSearchTerm = place;

    _clearOverlay();

    if (place.isEmpty) return;

    final RenderBox? searchInputBox = searchInputKey.currentContext?.findRenderObject() as RenderBox?;

    _suggestionsOverlayEntry = _createSuggestionsOverlay(searchInputBox);

    /// Insert the finding places in suggestions overlay entry
    Overlay.of(context).insert(_suggestionsOverlayEntry!);

    autoCompleteSearch(place);
  }

  /// Creates the rich suggestions overlay entry
  OverlayEntry _createSuggestionsOverlay(RenderBox? searchInputBox) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: searchInputBox?.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, ((searchInputBox?.size.height ?? 0) + 10.0)),
          showWhenUnlinked: false,
          child: Material(
            elevation: widget.autoCompleteOverlayElevation,
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),

              color: Theme.of(context).canvasColor,

              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Platform.isiOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator(),
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
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String place) async {
    try {
      place = place.replaceAll(" ", "+");

      final response = await googlePlacePickerService.autocomplete(
        place,
        sessionToken: sessionToken,
        language: widget.localizationConfig.languageCode,
        location: _geocodingResult?.latLng,
        radius: widget.autocompletePlacesSearchRadius,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load auto complete predictions of place: $place.');
      }

      final responseJson = jsonDecode(response.body);

      final predictions = responseJson['predictions'] as List<dynamic>?;

      final suggestions = _parseAutoCompleteSuggestions(predictions);

      displayAutoCompleteSuggestions(suggestions);

      if (responseJson["status"] != PlacesAutocompleteStatus.ok.status) {
        Future.error(responseJson.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  /// Builds the auto complete search endpoint
  String _buildAutoCompleteEndpoint(String place) {
    final locationQuery =
        locationResult != null ? '&location=${locationResult!.latLng?.latitude},${locationResult!.latLng?.longitude}' : '';

    return 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'key=${widget.apiKey}&'
        'language=${widget.localizationConfig.languageCode}&'
        'input=$place&sessiontoken=$sessionToken$locationQuery';
  }


  /// Parses the `predictions` into `RichSuggestion` array.
  List<RichSuggestion> _parseAutoCompleteSuggestions(List<dynamic>? predictions) {
    if (predictions == null || predictions.isEmpty) {
      return [
        RichSuggestion(
          autoCompleteItem: AutoCompleteItem()
            ..text = widget.localizationConfig.noResultsFound
            ..offset = 0
            ..length = 0,
        ),
      ];
    }

    return predictions.map((dynamic t) {
      final matchedSubstring = t['matched_substrings'][0];
      final aci = AutoCompleteItem()
        ..id = t['place_id']
        ..text = t['description']
        ..offset = matchedSubstring['offset']
        ..length = matchedSubstring['length'];

      return RichSuggestion(
        autoCompleteItem: aci,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          decodeAndSelectPlace(aci.id!);
        },
      );
    }).toList();
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox? searchInputBox = searchInputKey.currentContext?.findRenderObject() as RenderBox?;

    _clearOverlay();

    _suggestionsOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: searchInputBox?.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, ((searchInputBox?.size.height ?? 0) + 10.0)),
          child: Material(
            borderRadius: BorderRadius.circular(15.0),
            elevation: widget.autoCompleteOverlayElevation,
            child: ColoredBox(
              color: Theme.of(context).canvasColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: suggestions,
              ),
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
      final response = await googlePlacePickerService.details(
        placeId,
        language: widget.localizationConfig.languageCode,
        sessionToken: sessionToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch details of placeId: $placeId.');
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['result'] == null) {
        throw Error();
      }

      final location = responseJson['result']['geometry']['location'];
      if (mapController.isCompleted) {
        await animateToLocation(LatLng(location['lat'], location['lng']));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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

  /// Animates the camera to the provided location and
  /// updates other UI features to
  /// match the location.
  Future<void> animateToLocation(LatLng latLng) async {
    _isAnimating = true;

    final controller = await mapController.future;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: _zoom,
        ),
      ),
    );

    /// Set Marker
    if (!widget.usePinPointingSearch) setMarker(latLng);

    /// Reverse Geocode Lat Lng
    await reverseGeocodeLatLng(latLng);

    if (widget.enableNearbyPlaces) await getNearbyPlaces(latLng);

    _isAnimating = false;

    /// set searching state to idle
    setState(() {
      _searchingState = SearchingState.idle;
    });
  }

  void moveToCurrentUserLocation() async {
    if (widget.initialLocation != null) {
      animateToLocation(widget.initialLocation!);
    } else if (_currentLocation != null) {
      animateToLocation(_currentLocation!);
    } else {
      animateToLocation(PlacePicker.defaultLocation);
    }
  }

  /// Callback if user has enabled [myLocationButtonEnabled].
  /// Function will animate the camera to current location, given user has provided
  /// permission for location access.
  Future<void> _locateMe() async {
    try {
      /// set searching state as searching
      setState(() {
        _searchingState = SearchingState.searching;
      });

      /// get the current location of user
      final LatLng position = await _getCurrentLocation();
      animateToLocation(position);
    } catch (e) {
      if (e is LocationServiceDisabledException && mounted) {
        Navigator.of(context).pop();
      }
      debugPrint(e.toString());
    }
  }

  /// This method gets the human readable name of the location. Mostly appears
  /// to be the road name and the locality.
  Future<void> reverseGeocodeLatLng(LatLng latLng) async {
    try {
      final url = Uri.parse("${widget.mapsBaseUrl}geocode/json?"
          "latlng=${latLng.latitude},${latLng.longitude}&"
          "language=${widget.localizationConfig.languageCode}&"
          "key=${widget.apiKey}");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to geocode of location: $latLng.');
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Future.error("No results found.");
      }

      if (responseJson["status"] != PlacesDetailsStatus.ok.status) {
        Future.error(responseJson.toString());
      }

      /// clear the geocodingResultList
      _geocodingResultList.clear();

      final geocodingResponse = geocodingResponseFromJson(response.body);

      if (geocodingResponse.results != null &&
          geocodingResponse.results!.isNotEmpty) {
        /// Loop through all the results provided by google geocoding API
        for (int resultIdx = 0;
            resultIdx < geocodingResponse.results!.length;
            resultIdx++) {
          final GeocodingResultGG geocodingResultRaw =
              geocodingResponse.results![resultIdx];

          if (geocodingResultRaw.addressComponents != null &&
              geocodingResultRaw.addressComponents!.isNotEmpty) {
            /// Initialize the short and long variables
            String name = "";
            String? routeShortName,
                streetNumberShortName,
                localityShortName,
                postalCodeShortName,
                plusCodeShortName,
                countryShortName,
                administrativeAreaLevel1ShortName,
                administrativeAreaLevel2ShortName,
                subLocalityLevel1ShortName,
                subLocalityLevel2ShortName;

            String? routeLongName,
                streetNumberLongName,
                localityLongName,
                postalCodeLongName,
                plusCodeLongName,
                countryLongName,
                administrativeAreaLevel1LongName,
                administrativeAreaLevel2LongName,
                subLocalityLevel1LongName,
                subLocalityLevel2LongName;

            bool isOnStreet = false;

            /// initialize geocoding result
            LocationResult? geocodingResult;

            /// Loop through all the address components for each results
            for (int addressComponentsIdx = 0;
                addressComponentsIdx <
                    geocodingResultRaw.addressComponents!.length;
                addressComponentsIdx++) {
              final AddressComponentGG addressComponentRaw =
                  geocodingResultRaw.addressComponents![addressComponentsIdx];

              /// Types provided for each address components by geocoding API from google
              final types = addressComponentRaw.types;

              /// continue if types is either null or empty
              if (types == null && types!.isEmpty) continue;

              /// `short` and `long` names from google api
              final shortName = addressComponentRaw.shortName;
              final longName = addressComponentRaw.longName;

              /// Create the human readable name
              if (addressComponentsIdx == 0) {
                /// [street_number]
                name = shortName ?? "";
                isOnStreet = types.contains('street_number');

                /// other index 0 types
                /// [establishment, point_of_interest, subway_station, transit_station]
                /// [premise]
                /// [route]
              } else if (addressComponentsIdx == 1 && isOnStreet) {
                if (types.contains('route')) {
                  name += ", $shortName";
                }
              }

              if (types.contains("street_number")) {
                streetNumberLongName = longName;
                streetNumberShortName = shortName;
              } else if (types.contains("route")) {
                routeLongName = longName;
                routeShortName = shortName;
              } else if (types.contains("country")) {
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

              geocodingResult = LocationResult()
                ..name = name
                ..latLng = latLng
                ..formattedAddress = geocodingResultRaw.formattedAddress
                ..placeId = geocodingResultRaw.placeId
                ..streetNumber = AddressComponent(
                  longName: streetNumberLongName,
                  shortName: streetNumberShortName,
                )
                ..route = AddressComponent(
                  longName: routeLongName,
                  shortName: routeShortName,
                )
                ..country = AddressComponent(
                  longName: countryLongName,
                  shortName: countryShortName,
                )
                ..locality = AddressComponent(
                  longName:
                      localityLongName ?? administrativeAreaLevel1LongName,
                  shortName:
                      localityShortName ?? administrativeAreaLevel1ShortName,
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
            }

            if (geocodingResult != null) {
              _geocodingResultList.add(geocodingResult);
            }
          }
        }
      }

      /// if the geocoding result is list is not empty
      /// set _geocodingResult as the first element of the list
      if (_geocodingResultList.isNotEmpty) {
        _geocodingResult = _geocodingResultList.first;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Fetches and updates the nearby places to the provided lat,lng
  Future<void> getNearbyPlaces(LatLng latLng) async {
    try {

      final response = await googlePlacePickerService.nearbySearch(
        latLng,
        language: widget.localizationConfig.languageCode,
      );


      if (response.statusCode != 200) {
        throw Exception('Failed to fetch nearby places of location: $latLng.');
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Future.error("No results found.");
      }

      if (responseJson["status"] != NearbySearchStatus.ok.status) {
        Future.error(responseJson.toString());
      }

      nearbyPlaces.clear();

      for (Map<String, dynamic> item in responseJson['results']) {
        final nearbyPlace = NearbyPlace()
          ..name = item['name']
          ..icon = item['icon']
          ..latLng = LatLng(item['geometry']['location']['lat'], item['geometry']['location']['lng']);

        nearbyPlaces.add(nearbyPlace);
      }
    } catch (e) {
      ///
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
          return Future.error('Location Services is not enabled.');
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
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      /// Permissions are denied forever, handle appropriately.
      /// return widget.defaultLocation;
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    try {
      final locationData = await Geolocator.getCurrentPosition();
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
    if (Platform.isiOS) {
      return showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text("Location is disabled"),
              content: const Text("To use location, go to your Settings App > Privacy > Location Services."),
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
            content: const Text("The app needs to access your location. Please enable location service."),
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

  /// Utility function to get clean readable name of a location. First checks
  /// for a human-readable name from the nearby list. This helps in the cases
  /// that the user selects from the nearby list (and expects to see that as a
  /// result, instead of road name). If no name is found from the nearby list,
  /// then the road name returned is used instead.
  String? getLocationName() {
    if (_geocodingResult == null) {
      return widget.localizationConfig.unnamedLocation;
    }
    return _geocodingResult?.name;

  }

  /// Utility function to get clean readable formatted address of a location.
  String getFormattedLocationName() {
    if (_geocodingResult == null) {
      return widget.localizationConfig.unnamedLocation;
    }

    return "${_geocodingResult?.formattedAddress}";
  }
}
