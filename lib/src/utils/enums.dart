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

enum PinState {
  preparing,
  idle,
  dragging,
}

enum SearchingState {
  idle,
  searching,
}

enum PlacesAutocompleteStatus {
  ok(status: "OK"),
  zeroResults(status: "ZERO_RESULTS"),
  invalidRequest(status: "INVALID_REQUEST"),
  overQueryLimit(status: "OVER_QUERY_LIMIT"),
  requestDenied(status: "REQUEST_DENIED"),
  unknownError(status: "UNKNOWN_ERROR");

  const PlacesAutocompleteStatus({
    required this.status,
  });

  final String status;
}

enum PlacesDetailsStatus {
  ok(status: "OK"),
  zeroResults(status: "ZERO_RESULTS"),
  notFound(status: "NOT_FOUND"),
  invalidRequest(status: "INVALID_REQUEST"),
  overQueryLimit(status: "OVER_QUERY_LIMIT"),
  requestDenied(status: "REQUEST_DENIED"),
  unknownError(status: "UNKNOWN_ERROR");

  const PlacesDetailsStatus({
    required this.status,
  });

  final String status;
}

enum NearbySearchStatus {
  ok(status: "OK"),
  zeroResults(status: "ZERO_RESULTS"),
  invalidRequest(status: "INVALID_REQUEST"),
  overQueryLimit(status: "OVER_QUERY_LIMIT"),
  requestDenied(status: "REQUEST_DENIED"),
  unknownError(status: "UNKNOWN_ERROR");

  const NearbySearchStatus({
    required this.status,
  });

  final String status;
}
