import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:place_picker_google/place_picker_google.dart';
import 'package:place_picker_google/src/entities/google/index.dart';
import 'package:place_picker_google/src/services/index.dart';
import 'package:place_picker_google/src/utils/index.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  SearchingState state,
  LocationResult? selectedPlace,
);

typedef PinWidgetBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

typedef BackWidgetBuilder = Widget Function(
  BuildContext context,
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

  /// Search Input
  final bool showSearchInput;
  final SearchInputConfig searchInputConfig;
  final SearchInputDecorationConfig searchInputDecorationConfig;

  /// Nearby Places
  final TextStyle? nearbyPlaceItemStyle;
  final TextStyle? nearbyPlaceStyle;
  final bool enableNearbyPlaces;

  /// Selected Place
  @Deprecated("Use SelectedPlaceConfig.locationNameStyle from 0.0.15")
  final TextStyle? selectedLocationNameStyle;
  @Deprecated("Use SelectedPlaceConfig.formattedAddressStyle from 0.0.15")
  final TextStyle? selectedFormattedAddressStyle;
  @Deprecated("Use SelectedPlaceConfig.actionButtonText from 0.0.15")
  final Widget? selectedActionButtonChild;
  final SelectedPlaceConfig selectedPlaceConfig;

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

  /// Builder method for back button widget
  final BackWidgetBuilder? backWidgetBuilder;

  /// Radius in meters to narrow down the autocomplete places search results
  /// according to the current location
  @Deprecated("Use GoogleAPIParameters.radius from 0.0.17")
  final num? autocompletePlacesSearchRadius;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tap gestures.
  final bool tapGesturesEnabled;

  /// True if the map view should be in lite mode. Android only.
  ///
  /// See https://developers.google.com/maps/documentation/android-sdk/lite#overview_of_lite_mode for more details.
  final bool liteModeEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// True if 45 degree imagery should be enabled. Web only.
  final bool fortyFiveDegreeImageryEnabled;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// Identifier that's associated with a specific cloud-based map style.
  ///
  /// See https://developers.google.com/maps/documentation/get-map-id
  /// for more details.
  final String? cloudMapId;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// Tile overlays to be placed on the map.
  final Set<TileOverlay> tileOverlays;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// This setting controls how the API handles gestures on the map. Web only.
  ///
  /// See [WebGestureHandling] for more details.
  final WebGestureHandling? webGestureHandling;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  final GoogleAPIParameters googleAPIParameters;

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
    this.selectedPlaceConfig = const SelectedPlaceConfig.init(),
    this.myLocationFABConfig = const MyLocationFABConfig(),
    this.autoCompleteOverlayElevation = 0,
    this.usePinPointingSearch = false,
    this.pinPointingDebounceDuration = 500,
    this.pinPointingPinWidgetBuilder,
    this.autocompletePlacesSearchRadius,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tapGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.fortyFiveDegreeImageryEnabled = false,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.buildingsEnabled = true,
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.cloudMapId,
    this.onLongPress,
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.tileOverlays = const <TileOverlay>{},
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.circles = const <Circle>{},
    this.webGestureHandling,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.googleAPIParameters = const GoogleAPIParameters(),
    this.backWidgetBuilder,
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
  late final googleMapsPlacesService = GoogleMapsPlacesService(
    apiKey: widget.apiKey,
    baseUrl: widget.mapsBaseUrl,
    httpClient: widget.mapsHttpClient,
    apiHeaders: widget.mapsApiHeaders,
  );

  /// Google Common Service
  late final googleCommonService = GoogleMapsCommonService(
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

  /// Camera Position
  /// The position of the map "camera", the view point from which the world is shown in the map view.
  CameraPosition? cameraPosition;

  /// The selected nearby place if enabled.
  NearbyPlace? selectedNearbyPlace;

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
      final LatLng position =
          widget.initialLocation ?? await _getCurrentLocation();

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
    Widget mapWidget = _buildGoogleMap();
    mapWidget = widget.tapGesturesEnabled ? mapWidget : IgnorePointer(child: mapWidget);
    return Stack(
      children: [
        mapWidget,
        if (widget.showSearchInput) _buildSearchInput(),
        if (widget.myLocationButtonEnabled) _buildMyLocationButton(),
        if (widget.usePinPointingSearch) _buildPinPointingIndicator(),
      ],
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialLocation ??
            _currentLocation ??
            PlacePicker.defaultLocation,
        zoom: _getInitialZoom(),
      ),
      minMaxZoomPreference: widget.minMaxZoomPreference,
      mapType: widget.mapType,
      onTap: onTap,
      markers: markers,
      onMapCreated: onMapCreated,
      onCameraIdle: onCameraIdle,
      onCameraMoveStarted: onCameraMoveStarted,
      onCameraMove: onCameraMove,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      liteModeEnabled: widget.liteModeEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      fortyFiveDegreeImageryEnabled: widget.fortyFiveDegreeImageryEnabled,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      compassEnabled: widget.compassEnabled,
      mapToolbarEnabled: widget.mapToolbarEnabled,
      trafficEnabled: widget.trafficEnabled,
      cloudMapId: widget.cloudMapId,
      onLongPress: widget.onLongPress,
      polygons: widget.polygons,
      circles: widget.circles,
      cameraTargetBounds: widget.cameraTargetBounds,
      tileOverlays: widget.tileOverlays,
      gestureRecognizers: widget.gestureRecognizers,
      indoorViewEnabled: widget.indoorViewEnabled,
    );
  }

  double _getInitialZoom() {
    return (_currentLocation == null && widget.initialLocation == null)
        ? 4
        : _zoom;
  }

  Widget _buildLoadingIndicator() {
    return Platform.isiOS
        ? const CupertinoActivityIndicator()
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildSearchInput() {
    return SafeArea(
      child: Row(
        children: [
          if (widget.backWidgetBuilder != null)
            Builder(
              builder: (ctx) => widget.backWidgetBuilder!(ctx),
            ),
          Expanded(
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
          ),
        ],
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
      onNearbyPlaceClicked: (NearbyPlace nearbyPlace) {
        /// update the nearby place state variable and animate to location.
        selectedNearbyPlace = nearbyPlace;
        animateToLocation(nearbyPlace.latLng!);
      },
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

    /// remove selected nearby place
    selectedNearbyPlace = null;
    animateToLocation(position);
  }

  /// Debounce function for pin-pointing search
  void _debouncePinPointing(LatLng target) {
    _debounce?.cancel();
    _debounce =
        Timer(Duration(milliseconds: widget.pinPointingDebounceDuration), () {
      /// remove selected nearby place
      selectedNearbyPlace = null;
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
        heroTag: widget.myLocationFABConfig.heroTag,
        shape: widget.myLocationFABConfig.shape,
        elevation: widget.myLocationFABConfig.elevation,
        mini: widget.myLocationFABConfig.mini,
        tooltip: widget.myLocationFABConfig.tooltip,
        backgroundColor: widget.myLocationFABConfig.backgroundColor ??
            Theme.of(context).primaryColor,
        foregroundColor: widget.myLocationFABConfig.foregroundColor ??
            Theme.of(context).colorScheme.onPrimary,
        onPressed: _locateMe,
        child: widget.myLocationFABConfig.child ?? const Icon(Icons.gps_fixed),
      ),
    );
  }

  /// Selected Place Widget
  Widget _buildSelectedPlace() {
    if (widget.selectedPlaceWidgetBuilder == null) {
      return SafeArea(
        top: false,
        bottom: !widget.enableNearbyPlaces,
        child: SelectedPlace(
          locationName: getLocationName(),
          formattedAddress: getFormattedLocationName(),
          onTap: _geocodingResult != null
              ? () {
                  widget.onPlacePicked?.call(_geocodingResult!);
                }
              : null,
          selectedPlaceConfig: widget.selectedPlaceConfig,
        ),
      );
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

    final RenderBox? searchInputBox =
        searchInputKey.currentContext?.findRenderObject() as RenderBox?;

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
          offset: Offset(0, (searchInputBox?.size.height ?? 0)),
          showWhenUnlinked: false,
          child: Material(
            elevation: widget.autoCompleteOverlayElevation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: Theme.of(context).canvasColor,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Platform.isiOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator(),
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

  /// Parses the `predictions` into `RichSuggestion` array.
  List<RichSuggestion> _parseAutoCompleteSuggestions(
      List<dynamic>? predictions) {
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
          getDetailsAndSelectPlace(aci.id!);
        },
      );
    }).toList();
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
          offset: Offset(0, (searchInputBox?.size.height ?? 0)),
          child: Material(
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
    await _reverseGeocodeLatLng(latLng);

    if (widget.enableNearbyPlaces) await _getNearbyPlaces(latLng);

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

      /// remove selected nearby place
      selectedNearbyPlace = null;
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
  Future<void> _reverseGeocodeLatLng(LatLng latLng) async {
    try {
      final response = await googleCommonService.geocode(
        latLng: latLng,
        language: widget.googleAPIParameters.language,
        region: widget.googleAPIParameters.region,
      );

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
                administrativeAreaLevel3ShortName,
                administrativeAreaLevel4ShortName,
                administrativeAreaLevel5ShortName,
                administrativeAreaLevel6ShortName,
                administrativeAreaLevel7ShortName,
                subLocalityLevel1ShortName,
                subLocalityLevel2ShortName,
                subLocalityLevel3ShortName,
                subLocalityLevel4ShortName,
                subLocalityLevel5ShortName;

            String? routeLongName,
                streetNumberLongName,
                localityLongName,
                postalCodeLongName,
                plusCodeLongName,
                countryLongName,
                administrativeAreaLevel1LongName,
                administrativeAreaLevel2LongName,
                administrativeAreaLevel3LongName,
                administrativeAreaLevel4LongName,
                administrativeAreaLevel5LongName,
                administrativeAreaLevel6LongName,
                administrativeAreaLevel7LongName,
                subLocalityLevel1LongName,
                subLocalityLevel2LongName,
                subLocalityLevel3LongName,
                subLocalityLevel4LongName,
                subLocalityLevel5LongName;

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
              } else if (types.contains("sublocality_level_3")) {
                subLocalityLevel3LongName = longName;
                subLocalityLevel3ShortName = shortName;
              } else if (types.contains("sublocality_level_4")) {
                subLocalityLevel4LongName = longName;
                subLocalityLevel4ShortName = shortName;
              } else if (types.contains("sublocality_level_5")) {
                subLocalityLevel5LongName = longName;
                subLocalityLevel5ShortName = shortName;
              } else if (types.contains("administrative_area_level_1")) {
                administrativeAreaLevel1LongName = longName;
                administrativeAreaLevel1ShortName = shortName;
              } else if (types.contains("administrative_area_level_2")) {
                administrativeAreaLevel2LongName = longName;
                administrativeAreaLevel2ShortName = shortName;
              } else if (types.contains("administrative_area_level_3")) {
                administrativeAreaLevel3LongName = longName;
                administrativeAreaLevel3ShortName = shortName;
              } else if (types.contains("administrative_area_level_4")) {
                administrativeAreaLevel4LongName = longName;
                administrativeAreaLevel4ShortName = shortName;
              } else if (types.contains("administrative_area_level_5")) {
                administrativeAreaLevel5LongName = longName;
                administrativeAreaLevel5ShortName = shortName;
              } else if (types.contains("administrative_area_level_6")) {
                administrativeAreaLevel6LongName = longName;
                administrativeAreaLevel6ShortName = shortName;
              } else if (types.contains("administrative_area_level_7")) {
                administrativeAreaLevel7LongName = longName;
                administrativeAreaLevel7ShortName = shortName;
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
                ..nearbyPlace = selectedNearbyPlace
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
                ..administrativeAreaLevel3 = AddressComponent(
                  longName: administrativeAreaLevel3LongName,
                  shortName: administrativeAreaLevel3ShortName,
                )
                ..administrativeAreaLevel4 = AddressComponent(
                  longName: administrativeAreaLevel4LongName,
                  shortName: administrativeAreaLevel4ShortName,
                )
                ..administrativeAreaLevel5 = AddressComponent(
                  longName: administrativeAreaLevel5LongName,
                  shortName: administrativeAreaLevel5ShortName,
                )
                ..administrativeAreaLevel6 = AddressComponent(
                  longName: administrativeAreaLevel6LongName,
                  shortName: administrativeAreaLevel6ShortName,
                )
                ..administrativeAreaLevel7 = AddressComponent(
                  longName: administrativeAreaLevel7LongName,
                  shortName: administrativeAreaLevel7ShortName,
                )
                ..subLocalityLevel1 = AddressComponent(
                  longName: subLocalityLevel1LongName,
                  shortName: subLocalityLevel1ShortName,
                )
                ..subLocalityLevel2 = AddressComponent(
                  longName: subLocalityLevel2LongName,
                  shortName: subLocalityLevel2ShortName,
                )
                ..subLocalityLevel3 = AddressComponent(
                  longName: subLocalityLevel3LongName,
                  shortName: subLocalityLevel3ShortName,
                )
                ..subLocalityLevel4 = AddressComponent(
                  longName: subLocalityLevel4LongName,
                  shortName: subLocalityLevel4ShortName,
                )
                ..subLocalityLevel5 = AddressComponent(
                  longName: subLocalityLevel5LongName,
                  shortName: subLocalityLevel5ShortName,
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

  /// Fetches the place autocomplete list with the query [place].
  Future<void> autoCompleteSearch(String place) async {
    try {
      place = place.replaceAll(" ", "+");

      final response = await googleMapsPlacesService.autocomplete(
        place,
        sessionToken: widget.googleAPIParameters.sessionToken ?? sessionToken,
        offset: widget.googleAPIParameters.offset,
        origin: widget.googleAPIParameters.origin,
        radius: widget.googleAPIParameters.radius,
        language: widget.googleAPIParameters.language,
        region: widget.googleAPIParameters.region,
        components: widget.googleAPIParameters.components,
        types: widget.googleAPIParameters.types,
        location: _geocodingResult?.latLng,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load auto complete predictions of place: $place.');
      }

      final responseJson = jsonDecode(response.body);

      final status = responseJson["status"] as String?;
      final predictions = responseJson['predictions'] as List<dynamic>?;

      if (status == PlacesAutocompleteStatus.zeroResults.status) {
        /// Handle ZERO_RESULTS gracefully
        displayAutoCompleteSuggestions([]);
        debugPrint('No autocomplete predictions found for query: $place');
        return;
      }

      if (status != PlacesAutocompleteStatus.ok.status) {
        /// Log other non-OK statuses and clear suggestions
        debugPrint('Google Places API returned status: $status');
        displayAutoCompleteSuggestions([]);
      }

      final suggestions = _parseAutoCompleteSuggestions(predictions);
      displayAutoCompleteSuggestions(suggestions);
    } catch (e, stack) {
      /// Log error and clear suggestions as fallback
      debugPrint('Error in autoCompleteSearch: $e\n$stack');
      displayAutoCompleteSuggestions([]);
    }
  }

  /// To navigate to the selected place from the autocomplete list to the map,
  /// the lat,lng is required. This method fetches the lat,lng of the place and
  /// proceeds to moving the map to that location.
  Future<void> getDetailsAndSelectPlace(String placeId) async {
    _clearOverlay();

    try {
      final response = await googleMapsPlacesService.details(
        placeId,
        sessionToken: widget.googleAPIParameters.sessionToken ?? sessionToken,
        fields: widget.googleAPIParameters.fields,
        language: widget.googleAPIParameters.language,
        region: widget.googleAPIParameters.region,
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
        /// remove selected nearby place
        selectedNearbyPlace = null;
        await animateToLocation(LatLng(location['lat'], location['lng']));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Fetches and updates the nearby places to the provided lat,lng
  Future<void> _getNearbyPlaces(LatLng latLng) async {
    try {
      final response = await googleMapsPlacesService.nearbySearch(
        latLng,
        radius: widget.googleAPIParameters.radius ?? 150,
        language: widget.googleAPIParameters.language,
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
          ..latLng = LatLng(item['geometry']['location']['lat'],
              item['geometry']['location']['lng']);

        nearbyPlaces.add(nearbyPlace);
      }
    } catch (e) {
      ///
    }
  }

  /// Get current location API
  Future<LatLng> _getCurrentLocation() async {
    const fallbackLocation = PlacePicker.defaultLocation;
    const timeoutDuration = Duration(seconds: 10);

    /// 1. Ensure location services are enabled
    /// Test if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
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

    /// 2. Check permissions
    var permission = await Geolocator.checkPermission();
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    /// 3. Try to get current location
    try {
      final locationData =
          await Geolocator.getCurrentPosition().timeout(timeoutDuration);
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      debugPrint('target:$target');
      return target;
    } on TimeoutException catch (_) {
      final locationData = await Geolocator.getLastKnownPosition();
      if (locationData != null) {
        return LatLng(locationData.latitude, locationData.longitude);
      } else {
        return fallbackLocation;
      }
    } catch (e) {
      debugPrint('Location fetch error: $e');
      return fallbackLocation;
    }
  }

  Future<dynamic> _showLocationDisabledAlertDialog(BuildContext context) {
    if (Platform.isiOS) {
      return showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text("Location is disabled"),
              content: const Text(
                "To use location, go to your Settings App > Privacy > Location Services.",
              ),
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
              "The app needs to access your location. Please enable location service.",
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Geolocator.openLocationSettings().then((value) {
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

    if (selectedNearbyPlace != null) {
      return selectedNearbyPlace?.name;
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
