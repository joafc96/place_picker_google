class LocalizationConfig {
  final String languageCode;
  final String? nearBy;
  final String findingPlace;
  final String noResultsFound;

  /// Shown in the selected-place card while no place is selected: before the
  /// first result, and when the device location is unavailable until the
  /// user searches, taps the map or moves the pin.
  final String unnamedLocation;
  @Deprecated("Use SelectedPlaceConfig.actionButtonText from 0.0.15")
  final String? selectActionLocation;

  const LocalizationConfig({
    required this.languageCode,
    this.nearBy,
    required this.findingPlace,
    required this.noResultsFound,
    required this.unnamedLocation,
    this.selectActionLocation,
  });

  const LocalizationConfig.init({
    this.languageCode = 'en_us',
    this.nearBy = 'Nearby Places',
    this.findingPlace = 'Finding place...',
    this.noResultsFound = 'No results found',
    this.unnamedLocation = 'Unnamed location',
    this.selectActionLocation = 'Confirm Location',
  });
}
