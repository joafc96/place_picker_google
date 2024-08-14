class LocalizationConfig {
  final String languageCode;
  final String? nearBy;
  final String findingPlace;
  final String noResultsFound;
  final String unnamedLocation;
  final String? searchHint;
  final String? selectActionLocation;

  const LocalizationConfig({
    required this.languageCode,
    this.nearBy,
    required this.findingPlace,
    required this.noResultsFound,
    required this.unnamedLocation,
    required this.searchHint,
    this.selectActionLocation,
  });

  const LocalizationConfig.init({
    this.languageCode = 'en_us',
    this.nearBy = 'Nearby Places',
    this.findingPlace = 'Finding place...',
    this.noResultsFound = 'No results found',
    this.unnamedLocation = 'Unnamed location',
    this.searchHint = "Search Place...",
    this.selectActionLocation = 'Confirm Location',
  });
}
