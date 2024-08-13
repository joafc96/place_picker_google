class LocalizationConfig {
  final String languageCode;
  final String? nearBy;
  final String findingPlace;
  final String noResultsFound;
  final String unnamedLocation;
  final String? tapToSelectLocation;

  const LocalizationConfig({
    required this.languageCode,
    this.nearBy,
    required this.findingPlace,
    required this.noResultsFound,
    required this.unnamedLocation,
    this.tapToSelectLocation,
  });

  const LocalizationConfig.init({
    this.languageCode = 'en_us',
    this.nearBy = 'Nearby Places',
    this.findingPlace = 'Finding place...',
    this.noResultsFound = 'No results found',
    this.unnamedLocation = 'Unnamed location',
    this.tapToSelectLocation = 'Tap to select this location',
  });
}
